require 'rails_helper'

describe 'Usuário vê detalhes de um prato' do
  it 'a partir da tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)
    dish.illustration.attach(io: file_fixture('drink_test.jpg').open, filename: 'dish_test.jpg')

    login_as owner
    visit root_path
    click_on 'Provoleta de Cabra grelhada'

    expect(page).to have_content 'Provoleta de Cabra grelhada'
    expect(page).to have_css "img[src*='dish_test.jpg']"
    expect(page).to have_content 'Entrada'
    expect(page).to have_content 'Valor energético: 400 kcal'
  end

  it 'e o prato não tem calorias registradas' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada')

    login_as owner
    visit dish_path(dish)

    expect(page).not_to have_content 'Valor energético'
  end

  it 'e não há imagem cadastrada' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)

    login_as owner
    visit dish_path(dish)

    expect(page).to have_css "img[src*='item_placeholder']"
  end

  it 'e volta à tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)

    login_as owner
    visit dish_path(dish)
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
