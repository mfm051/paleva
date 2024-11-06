require 'rails_helper'

describe 'Dono adiciona porção a bebida' do
  it 'a partir da tela de detalhes' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85,
                              status: 'active')

    login_as owner
    visit drink_path(drink)
    click_on 'Adicionar porção'
    fill_in 'Descrição', with: 'Lata (350 mL)'
    fill_in 'Preço', with: '10.00'
    click_on 'Salvar'

    expect(current_path).to eq drink_path(drink)
    expect(page).to have_content 'Porção cadastrada com sucesso'
    expect(page).to have_content 'Lata (350 mL): R$ 10,00'
  end

  it 'e fornece informações inválidas' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85,
                              status: 'active')

    login_as owner
    visit new_drink_portion_path(drink)
    fill_in 'Descrição', with: ''
    fill_in 'Preço', with: -5
    click_on 'Salvar'

    expect(page).to have_content 'Porção não cadastrada'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Preço deve ser maior que 0'
  end

  it 'e volta à tela da bebida' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85,
                              status: 'active')

    login_as owner
    visit new_drink_portion_path(drink)
    click_on 'Voltar'

    expect(current_path).to eq drink_path(drink)
  end
end
