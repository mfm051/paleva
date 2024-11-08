require 'rails_helper'

describe 'Usuário busca um item do restaurante' do
  it 'se tiver restaurante registrado' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')

    login_as owner
    visit root_path

    within 'nav' do
      expect(page).not_to have_field 'Busca'
    end
  end

  it 'a partir de menu' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)
    restaurant.dishes.create!(name: 'Salada de Palmito e Agrião', description: 'Salada')
    restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)

    login_as owner
    visit root_path
    within 'nav' do
      fill_in 'Busca', with: 'provoleta'
      click_on 'Buscar'
    end

    expect(page).to have_content '1 prato encontrado:'
    expect(page).to have_content 'Provoleta de Cabra grelhada'
    expect(page).not_to have_content 'Salada de Palmito e Agrião'
    expect(page).not_to have_content 'Coca-cola'
  end

  it 'utilizando nome ou descrição' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Bom com Coca-cola', calories: 400)
    restaurant.dishes.create!(name: 'Torradinhas', description: 'Entrada')
    restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Refrigerante', calories: 85)


    login_as owner
    visit root_path
    fill_in 'Busca', with: 'Coca-cola'
    click_on 'Buscar'

    expect(page).to have_content '1 prato encontrado:'
    expect(page).to have_content 'Provoleta de Cabra grelhada'
    expect(page).to have_content '1 bebida encontrada:'
    expect(page).to have_content 'Coca-cola'
  end

  it 'e vê somente dados de seu próprio restaurante' do
    other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
    other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                            cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                            phone: '2736910853', email: 'paodelo@email.com')
    other_restaurant.dishes.create!(name: 'Torteletes de limão', description: 'Sobremesa azedinha')

    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    restaurant.drinks.create!(name: 'Suco de limão', alcoholic: false, description: 'Geladinho')

    login_as owner
    visit root_path
    fill_in 'Busca', with: 'limão'
    click_on 'Buscar'

    expect(page).to have_content 'Suco de limão'
    expect(page).not_to have_content 'Torteletes de limão'
  end

  it 'e não há itens para busca' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)
    restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)

    login_as owner
    visit root_path
    fill_in 'Busca', with: 'provolone'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum resultado de busca para provolone'
  end

  it 'e encontra mais de um item de cada tipo' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Bom com Coca-cola', calories: 400)
    restaurant.dishes.create!(name: 'Salada de Palmito e Agrião', description: 'Bom com Coca-cola também')
    restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)
    restaurant.drinks.create!(name: 'Pepsi', alcoholic: false, description: 'Não é Coca-cola', calories: 85)

    login_as owner
    visit root_path
    fill_in 'Busca', with: 'Coca-cola'
    click_on 'Buscar'

    expect(page).to have_content '2 pratos encontrados'
    expect(page).to have_content '2 bebidas encontradas'
  end

  it 'e tem acesso à tela de edição de um prato' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Bom com Coca-cola', calories: 400)

    login_as owner
    visit root_path
    fill_in 'Busca', with: 'Coca-cola'
    click_on 'Buscar'
    click_on 'Provoleta de Cabra grelhada'

    expect(current_path).to eq edit_dish_path(dish)
  end

  it 'e tem acesso à tela de edição de uma bebida' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)

    login_as owner
    visit root_path
    fill_in 'Busca', with: 'Coca-cola'
    click_on 'Buscar'
    click_on 'Coca-cola'
    expect(current_path).to eq edit_drink_path(drink)
  end

  it 'e volta à tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')

    login_as owner
    visit root_path
    fill_in 'Busca', with: 'Entrada'
    click_on 'Buscar'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
