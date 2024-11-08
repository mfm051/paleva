require 'rails_helper'

describe 'Usuário registra um restaurante' do
  it 'se estiver logado como dono' do
    post restaurant_path

    expect(response).to redirect_to new_owner_session_path
  end

  it 'se ainda não tiver um cadastrado' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    post restaurant_path, params: { restaurant: { brand_name: 'Nova Figueira Rubista' } }

    expect(response).to redirect_to restaurant
  end
end
