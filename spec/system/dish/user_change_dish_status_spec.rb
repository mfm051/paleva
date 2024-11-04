require 'rails_helper'

describe 'Usuário muda status de prato' do
  it 'a partir da tela de detalhes' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)

    login_as owner
    visit dish_path(dish)

    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_button 'Desativar'
  end

  it 'para inativo' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)

    login_as owner
    visit dish_path(dish)
    click_on 'Desativar'

    expect(page).to have_content 'Status: Inativo'
    expect(page).to have_button 'Ativar'
  end

  it 'para ativo' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400,
                                     status: 'inactive')

    login_as owner
    visit dish_path(dish)
    click_on 'Ativar'

    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_button 'Desativar'
  end
end
