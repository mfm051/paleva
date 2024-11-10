require 'rails_helper'

describe 'Dono cadastra menu para restaurante' do
  it 'a partir da tela de detalhes do restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)
    restaurant.dishes.create!(name: 'Salada Rubista', description: 'Entrada')
    restaurant.dishes.create!(name: 'Frango Caipira da Fazenda Rubista', description: 'Prato principal')
    restaurant.dishes.create!(name: 'Peixe do Dia', description: 'Prato principal')
    restaurant.dishes.create!(name: 'Purê de batatas', description: 'Acompanhamento')
    restaurant.dishes.create!(name: 'Farofa à Moda Rubista', description: 'Acompanhamento')

    restaurant.drinks.create!(name: 'Suco de Uva', description: 'Integral', alcoholic: false)
    restaurant.drinks.create!(name: 'Soda Italiana', description: 'Xarope de maçã verde e água com gás', alcoholic: false)

    login_as owner
    visit restaurant_path
    click_on 'Cardápios'
    click_on 'Novo cardápio'
    fill_in 'Nome', with: 'Executivo'
    within '#dishes' do
      check 'Salada Rubista'
      check 'Frango Caipira da Fazenda Rubista'
      check 'Farofa à Moda Rubista'
    end
    within '#drinks' do
      check 'Soda Italiana'
    end
    click_on 'Salvar'
    created_menu = restaurant.menus.last

    expect(current_path).to eq menu_path(created_menu)
    expect(page).to have_content 'Cardápio cadastrado com sucesso'
    expect(page).to have_content 'Executivo'
    expect(page).to have_content 'Salada Rubista'
    expect(page).to have_content 'Soda Italiana'
    expect(page).not_to have_content 'Provoleta de Cabra Grelhada'
    expect(page).not_to have_content 'Suco de Uva'
  end

  it 'se tiver algo para adicionar ao cardápio' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit menus_path

    expect(page).not_to have_link 'Novo cardápio'
    expect(page).to have_content 'Sem pratos ou bebidas para montar cardápio'
    expect(page).to have_link 'Novo prato'
    expect(page).to have_link 'Nova bebida'
  end

  it 'com pratos e bebidas ativos' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    restaurant.dishes.create!(status: 'active', name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)
    restaurant.dishes.create!(status: 'inactive', name: 'Salada Rubista', description: 'Entrada')

    restaurant.drinks.create!(status: 'active', name: 'Suco de Uva', description: 'Integral', alcoholic: false)
    restaurant.drinks.create!(status: 'inactive', name: 'Soda Italiana', description: 'Xarope de maçã verde e água com gás',
                             alcoholic: false)

    login_as owner
    visit new_menu_path

    expect(page).not_to have_field 'Salada Rubista'
    expect(page).not_to have_field 'Soda Italiana'
  end

  it 'com pratos e bebidas do próprio restaurante' do
    other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
    other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                            cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                            phone: '2736910853', email: 'paodelo@email.com')
    other_restaurant.dishes.create!(name: 'Torteletes de limão', description: 'Sobremesa azedinha')
    other_restaurant.drinks.create!(name: 'Suco de limão', description: 'Suco azedinho', alcoholic: false)

    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')

    login_as owner
    visit new_menu_path

    expect(page).not_to have_field 'Torteletes de limão'
    expect(page).not_to have_field 'Suco de limão'
  end

  it 'e fornece dados inválidos' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    restaurant.dishes.create!(status: 'active', name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)
    restaurant.drinks.create!(status: 'active', name: 'Suco de Uva', description: 'Integral', alcoholic: false)

    login_as owner
    visit new_menu_path
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Cardápio não cadastrado'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'e volta à tela de cardápios' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    restaurant.dishes.create!(status: 'active', name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)

    login_as owner
    visit new_menu_path
    click_on 'Voltar'

    expect(current_path).to eq menus_path
  end
end
