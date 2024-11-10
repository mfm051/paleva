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
    expect(page).to have_content 'Cardápio registrado com sucesso'
    expect(page).to have_content 'Executivo'
    expect(page).to have_content 'Salada Rubista'
    expect(page).to have_content 'Soda Italiana'
    expect(page).not_to have_content 'Provoleta de Cabra Grelhada'
    expect(page).not_to have_content 'Suco de Uva'
  end
end
