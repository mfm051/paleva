require 'rails_helper'

describe 'Usuário edita cardápio' do
  it 'se estiver autenticado' do
    fake_menu_id = 1

    patch menu_path(fake_menu_id)

    expect(response).to redirect_to new_owner_session_path
  end

  it 'se tiver restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    fake_menu_id = 1

    login_as owner
    patch menu_path(fake_menu_id)

    expect(response).to redirect_to new_restaurant_path
  end

  it 'se não invalidar cardápio' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Suco de maçã', description: '100% da fruta', alcoholic: false)
    menu = restaurant.menus.create!(name: 'Executivo', drinks: [drink])

    login_as owner
    patch menu_path(menu), params: { menu: { name: '' } }

    expect(menu.name).to eq 'Executivo'
  end

  it 'com seus próprios pratos' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                           password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Suco de maçã', description: '100% da fruta', alcoholic: false)
    menu = restaurant.menus.create!(name: 'Executivo', drinks: [drink])

    other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
    other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                      cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                      phone: '2736910853', email: 'paodelo@email.com')
    other_dish = other_restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada')

    login_as owner
    patch menu_path(menu), params: { menu: { dish_ids: [other_dish.id] } }

    expect(menu.dishes).to be_empty
  end

  it 'com suas próprias bebidas' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                           password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada')
    menu = restaurant.menus.create!(name: 'Executivo', dishes: [dish])

    other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
    other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                      cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                      phone: '2736910853', email: 'paodelo@email.com')
    other_drink = other_restaurant.drinks.create!(name: 'Suco de maçã', description: '100% da fruta', alcoholic: false)

    login_as owner
    patch menu_path(menu), params: { menu: { drink_ids: [other_drink.id] } }

    expect(menu.drinks).to be_empty
  end
end
