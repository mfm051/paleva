require 'rails_helper'

describe 'Usuário abre cardápio' do
  it 'a partir da tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Suco de limão', description: 'Também conhecido como limonada',
                                       alcoholic: false)
    dish = restaurant.dishes.create!(name: 'Feijoada', description: 'Prato principal')

    menu = restaurant.menus.create!(name: 'Almoço', drinks: [drink], dishes: [dish])

    login_as owner
    visit root_path
    click_on 'Almoço'

    expect(current_path).to eq menu_path(menu)
    expect(page).to have_content 'Almoço'
    expect(page).to have_content 'Pratos'
    expect(page).to have_link 'Feijoada'
    expect(page).to have_content 'Bebidas'
    expect(page).to have_link 'Suco de limão'
  end

  it 'e vê apenas itens ativos' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')

    dish_active = restaurant.dishes.create!(status: 'active', name: 'Feijoada', description: 'Prato principal')
    dish_inactive = restaurant.dishes.create!(status: 'inactive', name: 'Rabada', description: 'Prato principal')

    drink_active = restaurant.drinks.create!(status: 'active', name: 'Suco de limão', description: 'Também conhecido como limonada',
                                             alcoholic: false)
    drink_inactive = restaurant.drinks.create!(status: 'inactive', name: 'Suco de tomate', description: 'Feito com tomates orgânicos',
                                               alcoholic: false)

    menu = restaurant.menus.create!(name: 'Almoço', dishes: [dish_active, dish_inactive], drinks: [drink_active, drink_inactive])

    login_as owner
    visit menu_path(menu)

    expect(page).not_to have_link drink_inactive.name
    expect(page).to have_link drink_active.name
    expect(page).not_to have_link dish_inactive.name
    expect(page).to have_link dish_active.name
  end

  it 'e não há pratos ativos' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    dish_inactive = restaurant.dishes.create!(status: 'inactive', name: 'Rabada', description: 'Prato principal')
    drink = restaurant.drinks.create!(name: 'Suco de limão', description: 'Também conhecido como limonada',
                                      alcoholic: false)
    menu = restaurant.menus.create!(name: 'Almoço', drinks: [drink], dishes: [dish_inactive])

    login_as owner
    visit menu_path(menu)

    expect(page).to have_content 'Não há pratos ativos para esse cardápio'
  end

  it 'e não há bebidas ativas' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    drink_inactive = restaurant.drinks.create!(status: 'inactive', name: 'Suco de limão', alcoholic: false,
                                               description: 'Também conhecido como limonada')
    menu = restaurant.menus.create!(name: 'Almoço', drinks: [drink_inactive])

    login_as owner
    visit menu_path(menu)

    expect(page).to have_content 'Não há bebidas ativas para esse cardápio'
  end

  it 'e não vê itens de cardápio de outro restaurante' do
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

    other_restaurant.menus.create!(name: 'Mistura esquisita', drinks: [other_drink])

    login_as owner
    visit menu_path(menu)

    expect(page).not_to have_link other_drink.name
  end
end
