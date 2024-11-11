require 'rails_helper'

describe 'Usuário vê cardápios do restaurante' do
  it 'na tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink1 = restaurant.drinks.create!(name: 'Suco de limão', description: 'Também conhecido como limonada',
                                       alcoholic: false)
    drink2 = restaurant.drinks.create!(name: 'Caipirinha', description: 'Suco de limão +18', alcoholic: true)

    dish1 = restaurant.dishes.create!(name: 'Feijoada', description: 'Prato principal')
    dish2 = restaurant.dishes.create!(name: 'Salada', description: 'Acompanhamento')

    menu1 = restaurant.menus.create!(name: 'Almoço', drinks: [drink1], dishes: [dish1, dish2])
    menu2 = restaurant.menus.create!(name: 'Almoço com álcool', drinks: [drink2], dishes: [dish2, dish2])

    login_as owner
    visit root_path

    expect(page).to have_content 'Cardápios'
    expect(page).to have_link menu1.name
    expect(page).to have_link menu2.name
  end

  it 'se estiver autenticado' do
    visit root_path

    expect(current_path).to eq new_owner_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'se tiver restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    login_as owner
    visit root_path

    expect(current_path).to eq new_restaurant_path
    expect(page).to have_content 'Para continuar, registre seu estabelecimento'
  end

  it 'se existirem cardápios' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path

    expect(page).to have_content 'Não há cardápios registrados'
  end

  it 'e não vê cardápios de outro restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Suco de limão', description: 'Também conhecido como limonada',
                                       alcoholic: false)
    dish = restaurant.dishes.create!(name: 'Feijoada', description: 'Prato principal')

    menu = restaurant.menus.create!(name: 'Almoço', drinks: [drink], dishes: [dish])

    other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
    other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                            cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                            phone: '2736910853', email: 'paodelo@email.com')
    other_drink = other_restaurant.drinks.create!(name: 'Caipirinha', description: 'Suco de limão +18', alcoholic: true)
    other_dish = other_restaurant.dishes.create!(name: 'Salada', description: 'Acompanhamento')

    other_menu = other_restaurant.menus.create!(name: 'Mistura esquisita', drinks: [other_drink], dishes: [other_dish])

    login_as owner
    visit root_path

    expect(page).to have_link menu.name
    expect(page).not_to have_link other_menu.name
  end
end
