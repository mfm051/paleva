require 'rails_helper'

describe 'Usuário edita prato' do
  it 'a partir da tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)

    login_as owner
    visit root_path
    click_on 'Provoleta de Cabra grelhada'
    fill_in 'Nome', with: 'Provoleta de Cabra assada'
    fill_in 'Descrição', with: 'Prato principal leve'
    fill_in 'Quantidade de calorias', with: '450'
    click_on 'Salvar'

    expect(current_path).to eq edit_dish_path(dish)
    expect(page).to have_content 'Prato atualizado com sucesso'
    expect(page).to have_field 'Nome', with: 'Provoleta de Cabra assada'
    expect(page).to have_field 'Descrição', with: 'Prato principal leve'
    expect(page).to have_field 'Quantidade de calorias', with: '450'
  end
end
