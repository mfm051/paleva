require 'rails_helper'

describe 'Usuário registra um prato para seu estabelecimento' do
  it 'a partir da tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path
    click_on 'Novo prato'
    fill_in 'Nome', with: 'Provoleta de Cabra grelhada'
    fill_in 'Descrição', with: 'Entrada'
    fill_in 'Quantidade de calorias', with: '100'
    click_on 'Salvar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Prato cadastrado com sucesso'
    expect(page).to have_content 'Provoleta de Cabra grelhada'
  end

  it 'e volta à tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path
    click_on 'Novo prato'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
