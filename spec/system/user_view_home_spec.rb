require 'rails_helper'

describe 'Usuário vê tela inicial' do
  it 'somente se já tiver restaurante cadastrado' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    login_as owner
    visit root_path

    expect(page).to have_content 'Para continuar, registre seu estabelecimento'
  end

  it 'e vê pratos do restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400, status: 'active')
    with_image = restaurant.dishes.create!(name: 'Salada de Palmito e Agrião', description: 'Salada', status: 'inactive')

    with_image.illustration.attach(io: file_fixture('dish_test.jpg').open, filename: 'dish_test.jpg')

    login_as owner
    visit root_path

    expect(page).to have_content 'Pratos'
    expect(page).to have_content 'Provoleta de Cabra grelhada (ativo)'
    expect(page).to have_content 'Salada de Palmito e Agrião (inativo)'
    expect(page).to have_css "img[src*='dish_test.jpg']"
  end

  it 'e não há pratos cadastrados' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as(owner)
    visit root_path

    expect(page).to have_content 'Ainda não há pratos cadastrados'
  end

  it 'e vê bebidas do restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85,
                              status: 'active')
    drink = restaurant.drinks.create!(name: 'Mistério', alcoholic: true, description: 'Vermouth Dourado infusionado'\
                                      ' com grãos de café, Bacardi 8 anos, licor Grand Marnier e Bitter Aromatic.',
                                      status: 'inactive')

    drink.illustration.attach(io: file_fixture('drink_test.jpg').open, filename: 'drink_test.jpg')

    login_as(owner)
    visit root_path

    expect(page).to have_content 'Bebidas'
    expect(page).to have_content 'Coca-cola (ativo)'
    expect(page).to have_content 'Mistério (inativo)'
    expect(page).to have_css "img[src*='drink_test.jpg']"
  end

  it 'e não há bebidas cadastradas' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as(owner)
    visit root_path

    expect(page).to have_content 'Ainda não há bebidas cadastradas'
  end
end
