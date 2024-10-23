require 'rails_helper'

describe 'Usuário vê seu restaurante' do
  it 'somente após criar sua conta' do
    visit root_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end
end
