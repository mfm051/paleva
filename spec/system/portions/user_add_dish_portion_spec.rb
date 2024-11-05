require 'rails_helper'

describe 'Dono adiciona porção a um prato' do
  it 'a partir da tela de detalhes' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400,
                                    status: 'active')

    login_as owner
    visit dish_path(dish)
    click_on 'Adicionar porção'
    fill_in 'Descrição', with: 'Porção pequena'
    fill_in 'Preço', with: '30.00'
    click_on 'Salvar'

    expect(current_path).to eq dish_path(dish)
    expect(page).to have_content 'Porção pequena: R$ 30,00'
  end
end
