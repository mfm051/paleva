require 'rails_helper'

describe 'Usuário edita prato' do
  it 'se estiver autenticado' do
    fake_dish_id = 1

    patch dish_path fake_dish_id

    expect(response).to redirect_to new_owner_session_path
  end

  it 'se tiver restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    fake_dish_id = 1

    login_as owner
    patch dish_path(fake_dish_id)

    expect(response).to redirect_to new_restaurant_path
  end

  it 'de seu próprio restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')

    other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                          password: '123456789012')
    other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                      cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                      phone: '2736910853', email: 'paodelo@email.com')
    other_dish = other_restaurant.dishes.create!(name: 'Moqueca de peixe', description: 'Moqueca baiana, a original')

    login_as owner
    patch dish_path(other_dish), params: { dish: { name: 'Moqueca capixaba' } }

    expect(response).to redirect_to restaurant
    expect(other_restaurant.dishes.last.name).to eq 'Moqueca de peixe'
  end
end
