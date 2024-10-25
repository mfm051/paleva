require 'rails_helper'

describe 'Usuário entra em sua conta' do
  it 'antes de qualquer ação' do
    visit root_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se'
    expect(page).not_to have_button 'Sair'
  end

  it 'com sucesso' do
    Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    visit root_path
    fill_in 'E-mail', with: 'paula@email.com'
    fill_in 'Senha', with: '123456789012'
    click_on 'Entrar'

    expect(page).to have_button 'Sair'
  end

  it 'e sai através de menu' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    login_as(owner)
    visit root_path
    within('nav') do
      click_on('Sair')
    end

    expect(current_path).to eq new_owner_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end
end
