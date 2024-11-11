require 'rails_helper'

describe 'Dono vê detalhes de bebida' do
  it 'a partir de menu que o contenha' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)
    drink.illustration.attach(io: file_fixture('drink_test.jpg').open, filename: 'drink_test.jpg')
    drink.portions.create!(description: 'Lata (350ml)', price: 800)
    drink.portions.create!(description: 'Garrafa (1 litro)', price: 1200 )

    restaurant.menus.create!(name: 'Lanche', drinks: [drink])

    login_as owner
    visit root_path
    click_on 'Lanche'
    click_on 'Coca-cola'

    expect(page).to have_content 'Coca-cola'
    expect(page).to have_content 'Só uma Coca-cola'
    expect(page).to have_content 'Valor energético: 85 kcal'
    expect(page).to have_content "Não contém álcool"
    expect(page).to have_content "Lata (350ml): R$ 8,00"
    expect(page).to have_content "Garrafa (1 litro): R$ 12,00"
    expect(page).to have_css "img[src*='drink_test.jpg']"
  end

  it 'e produto é alcóolico e não tem imagem cadastrada' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Mistério', alcoholic: true, description: 'Vermouth Dourado infusionado'\
                            ' com grãos de café, Bacardi 8 anos, licor Grand Marnier e Bitter Aromatic.')

    login_as owner
    visit drink_path(drink)

    expect(page).not_to have_content 'Não contém álcool'
    expect(page).to have_content 'Contém álcool'
    expect(page).to have_css "img[src*='item_placeholder']"
  end

  it 'e não há porções cadastradas' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)

    login_as owner
    visit drink_path(drink)

    expect(page).to have_content 'Não há porções cadastradas'
  end

  it 'e volta à tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)

    login_as owner
    visit drink_path(drink)
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
