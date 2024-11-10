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

  it 'se for dono do prato' do
    other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
    other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                      cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                      phone: '2736910853', email: 'paodelo@email.com')
    other_dish = other_restaurant.dishes.create!(name: 'Torteletes de limão', description: 'Sobremesa azedinha')
    other_portion = other_dish.portions.create!(description: '5 unidades', price: 5000)

    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')

    login_as owner
    visit edit_dish_portion_path(other_dish, other_portion)

    expect(page).not_to have_field 'Preço'
    expect(page).not_to have_button 'Enviar'
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
    visit edit_dish_portion_path(dish, portion)

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
    visit edit_dish_portion_path(dish, portion)
    fill_in 'Preço', with: 0
    click_on 'Salvar'

    expect(page).to have_content 'Porção não atualizada'
    expect(page).to have_content 'Preço deve ser maior que 0'
    expect(dish.portions.last.price).to eq 3000
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
    visit edit_dish_portion_path(dish, portion)
    click_on 'Voltar'

    expect(current_path).to eq dish_path(dish)
  end
end
