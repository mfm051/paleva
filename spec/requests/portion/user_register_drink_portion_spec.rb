require 'rails_helper'

describe 'Usuário adiciona porção a uma bebida' do
  it 'se estiver autenticado' do
    fake_drink_id = 1

    post drink_portions_path(fake_drink_id)

    expect(response).to redirect_to new_owner_session_path
  end

  it 'se tiver um restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                            password: '123456789012')
    fake_drink_id = 1

    login_as owner
    post drink_portions_path(fake_drink_id)

    expect(response).to redirect_to new_restaurant_path
  end

  it 'se for dono da bebida' do
    other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                              password: '123456789012')
    other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                      cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                      phone: '2736910853', email: 'paodelo@email.com')
    other_drink = other_restaurant.drinks.create!(name: 'Suco de uva', description: 'o original', alcoholic: false)

    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                            password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    post drink_portions_path(other_drink)

    expect(response).to redirect_to restaurant
  end
end
