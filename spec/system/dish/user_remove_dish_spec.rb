require 'rails_helper'

describe 'Usuário remove um prato de seu estabelecimento' do
  it 'a partir da tela de detalhes' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)
    restaurant.dishes.create!(name: 'Salada de Palmito e Agrião', description: 'Salada')

    login_as(owner)
    visit dish_path(dish)
    click_on 'Remover prato'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Prato removido com sucesso'
    expect(page).not_to have_content 'Provoleta de Cabra grelhada'
    expect(page).to have_content 'Salada de Palmito e Agrião'
  end
end
