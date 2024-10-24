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
    within('form') do
      click_on 'Cadastrar'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Restaurante cadastrado com sucesso'
    expect(page).to have_content 'A Figueira Rubista'
  end
end
