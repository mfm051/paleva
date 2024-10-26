require 'rails_helper'

describe 'Usuário edita bebida' do
  it 'a partir da tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)

    login_as(owner)
    visit root_path
    click_on 'Coca-cola'
    fill_in 'Nome', with: 'Cerveja da casa'
    fill_in 'Descrição', with: 'artesanal'
    fill_in 'Quantidade de calorias', with: '100'
    check 'Alcoólica'
    click_on 'Salvar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Cerveja da casa'
    expect(page).to have_content 'artesanal'
    expect(page).to have_content 'Valor energético: 100 kcal'
    expect(page).to have_content 'contém álcool'
  end
end
