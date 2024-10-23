require 'rails_helper'

describe 'Usuário vê seu restaurante na tela inicial' do
  it 'somente após criar sua conta' do
    visit root_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'somente se já o tiver cadastrado' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    login_as(owner)
    visit root_path

    expect(page).to have_content 'Para continuar, registre seu estabelecimento'
  end
end
