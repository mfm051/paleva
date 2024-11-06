require 'rails_helper'

describe 'Dono edita porção de prato' do
  it 'a partir da tela de detalhes' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400,
                                    status: 'active')
    dish.portions.create!(description: 'Porção pequena', price: 3000)

    login_as owner
    visit dish_path(dish)
    click_on 'Porção pequena'
    fill_in 'Preço', with: '35.00'
    click_on 'Salvar'

    expect(current_path).to eq dish_path(dish)
    expect(page).to have_content 'Porção atualizada com sucesso'
    expect(page).to have_content 'R$ 35,00'
    expect(page).not_to have_content 'R$ 30,00'
  end

  it 'e não vê opção de editar nome' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400,
                                    status: 'active')
    portion = dish.portions.create!(description: 'Porção pequena', price: 3000)

    login_as owner
    visit edit_portion_path(portion)

    expect(page).not_to have_field 'Descrição'
  end

  it 'e invalida preço' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400,
                                    status: 'active')
    portion = dish.portions.create!(description: 'Porção pequena', price: 3000)

    login_as owner
    visit edit_portion_path(portion)
    fill_in 'Preço', with: 0
    click_on 'Salvar'

    expect(page).to have_content 'Porção não atualizada'
    expect(page).to have_content 'Preço deve ser maior que 0'
  end

  it 'e volta à tela de prato' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
    password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
      cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
      email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400,
              status: 'active')
    portion = dish.portions.create!(description: 'Porção pequena', price: 3000)

    login_as owner
    visit edit_portion_path(portion)
    click_on 'Voltar'

    expect(current_path).to eq dish_path(dish)
  end
end
