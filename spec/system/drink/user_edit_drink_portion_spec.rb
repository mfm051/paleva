require 'rails_helper'

describe 'Dono edita porção de bebida' do
  it 'a partir da tela de detalhes' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85,
                              status: 'active')
    drink.portions.create!(description: 'Lata (350ml)', price: 800)

    login_as owner
    visit drink_path(drink)
    click_on 'Lata (350ml)'
    fill_in 'Preço', with: '10.00'
    click_on 'Salvar'

    expect(current_path).to eq drink_path(drink)
    expect(page).to have_content 'Porção atualizada com sucesso'
    expect(page).to have_content 'R$ 10,00'
  end

  it 'e não vê opção de mudar nome' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85,
                              status: 'active')
    portion = drink.portions.create!(description: 'Lata (350ml)', price: 800)

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
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85,
                              status: 'active')
    portion = drink.portions.create!(description: 'Lata (350ml)', price: 800)

    login_as owner
    visit edit_portion_path(portion)
    fill_in 'Preço', with: '-8,00'
    click_on 'Salvar'

    expect(page).to have_content 'Porção não atualizada'
    expect(page).to have_content 'Preço deve ser maior que 0'
    expect(drink.portions.last.price).to eq 800
  end

  it 'e volta à tela da bebida' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85,
                              status: 'active')
    portion = drink.portions.create!(description: 'Lata (350ml)', price: 800)

    login_as owner
    visit edit_portion_path(portion)
    click_on 'Voltar'

    expect(current_path).to eq drink_path(drink)
  end
end
