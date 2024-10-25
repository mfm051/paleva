require 'rails_helper'

describe 'Usuário cadastra bebida' do
  it 'a partir da tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path
    click_on 'Nova bebida'
    fill_in 'Nome', with: 'Drink da casa'
    fill_in 'Descrição', with: 'Bebida chique'
    fill_in 'Quantidade de calorias', with: '10'
    check 'Alcoólica'
    click_on 'Salvar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bebida cadastrada com sucesso'
    expect(page).to have_content 'Drink da casa'
    expect(page).to have_content 'contém álcool'
  end

  it 'e não seleciona opção de bebida alcoólica' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path
    click_on 'Nova bebida'
    fill_in 'Nome', with: 'Coca-cola'
    fill_in 'Descrição', with: 'Refrigerante'
    fill_in 'Quantidade de calorias', with: '10'
    click_on 'Salvar'

    expect(page).not_to have_content 'contém álcool'
  end

  it 'e não preenche campo corretamente' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path
    click_on 'Nova bebida'
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Bebida não cadastrada'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'e volta à tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path
    click_on 'Nova bebida'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
