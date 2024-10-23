require 'rails_helper'

describe 'Dono de restaurante cria sua conta' do
  it 'com sucesso' do
    visit root_path
    click_on 'Criar conta'
    fill_in 'Nome', with: 'Paula'
    fill_in 'Sobrenome', with: 'Groselha'
    fill_in 'CPF', with: '34423090007'
    fill_in 'E-mail', with: 'paula@email.com'
    fill_in 'Senha', with: '123456789012'
    fill_in 'Confirme sua senha', with: '123456789012'
    within('form') do
      click_on 'Criar conta'
    end

    expect(current_path).to eq new_restaurant_path
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
  end
end
