require 'rails_helper'

describe 'usuário edita cardápio' do
  it 'na tela de detalhes do cardápio' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Salada Rubista', description: 'Entrada')
    dish_not_in_menu = restaurant.dishes.create!(name: 'Purê de batatas', description: 'Acompanhamento')
    drink = restaurant.drinks.create!(name: 'Suco de Uva', description: 'Integral', alcoholic: false)

    menu = restaurant.menus.create!(name: 'Executivo', drinks: [drink], dishes: [dish])

    login_as owner
    visit menus_path
    click_on 'Executivo'
    click_on 'Editar'
    fill_in 'Nome', with: 'Fã de batatas'
    uncheck dish.name
    check dish_not_in_menu.name
    uncheck drink.name
    click_on 'Salvar'

    expect(current_path).to eq menu_path(menu)
    expect(page).to have_content 'Cardápio atualizado com sucesso'
    expect(page).not_to have_content menu.name
    expect(page).to have_content 'Fã de batatas'
    expect(page).not_to have_content dish.name
    expect(page).not_to have_content drink.name
    expect(page).to have_content dish_not_in_menu.name
  end

  it 'com pratos e bebidas ativos' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    dish_in_menu = restaurant.dishes.create!(name: 'Salada Rubista', description: 'Entrada')
    menu = restaurant.menus.create!(name: 'Executivo', dishes: [dish_in_menu])

    dish_active = restaurant.dishes.create!(status: 'active', name: 'Purê de batatas', description: 'Acompanhamento')
    drink_inactive = restaurant.drinks.create!(status: 'inactive', name: 'Suco de Uva', description: 'Integral',
                                               alcoholic: false)

    login_as owner
    visit edit_menu_path(menu)

    expect(page).to have_field dish_active.name
    expect(page).not_to have_field drink_inactive.name
  end

  it 'com pratos e bebidas do próprio restaurante' do
    other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
    other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                            cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                            phone: '2736910853', email: 'paodelo@email.com')
    other_dish = other_restaurant.dishes.create!(name: 'Torteletes de limão', description: 'Sobremesa azedinha')

    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    dish_in_menu = restaurant.dishes.create!(name: 'Salada Rubista', description: 'Entrada')
    menu = restaurant.menus.create!(name: 'Executivo', dishes: [dish_in_menu])

    login_as owner
    visit edit_menu_path(menu)

    expect(page).not_to have_field other_dish.name
  end

  it 'e invalida cardápio' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Salada Rubista', description: 'Entrada')

    menu = restaurant.menus.create!(name: 'Executivo', dishes: [dish])
    other_menu = restaurant.menus.create!(name: 'Café da manhã', dishes: [dish])

    login_as owner
    visit edit_menu_path(menu)
    fill_in 'Nome', with: other_menu.name
    click_on 'Salvar'

    expect(page).to have_content 'Cardápio não atualizado'
    expect(page).to have_content 'Nome já está em uso'
  end

  it 'e volta à tela de cardápios' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Salada Rubista', description: 'Entrada')

    menu = restaurant.menus.create!(name: 'Executivo', dishes: [dish])

    login_as owner
    visit edit_menu_path(menu)
    click_on 'Voltar'

    expect(current_path).to eq menus_path
  end
end
