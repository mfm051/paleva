require 'rails_helper'

describe 'Usuário registra seu estabelecimento' do
  it 'com sucesso' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    login_as(owner)
    visit root_path
    fill_in 'Nome fantasia', with: 'A Figueira Rubista'
    fill_in 'Razão social', with: 'Figueira Rubista LTDA'
    fill_in 'CNPJ', with: '25401196000157'
    fill_in 'Endereço', with: 'Rua das Flores, 10'
    fill_in 'Telefone', with: '1525017617'
    fill_in 'E-mail', with: 'afigueira@email.com'

    click_on 'Cadastrar'

    expect(current_path).to eq restaurant_path
    expect(page).to have_content 'Restaurante cadastrado com sucesso'
    expect(page).to have_content 'A Figueira Rubista'
  end

  it 'e não preenche campo adequadamente' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    login_as(owner)
    visit root_path
    fill_in 'Nome fantasia', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Restaurante não cadastrado'
    expect(page).to have_content 'Nome fantasia não pode ficar em branco'
  end
end
