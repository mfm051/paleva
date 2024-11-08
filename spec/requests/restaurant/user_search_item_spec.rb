require 'rails_helper'

describe 'Usuário busca um item do restaurante' do
  it 'se estiver logado' do
    get search_path

    expect(response).to redirect_to new_owner_session_path
  end

  it 'se tiver restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')

    login_as owner
    get search_path

    expect(response).to redirect_to new_restaurant_path
  end
end
