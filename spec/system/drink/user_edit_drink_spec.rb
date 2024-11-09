require 'rails_helper'

describe 'Usuário edita bebida' do
  it 'a partir da tela de detalhes' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)
    drink.illustration.attach(io: file_fixture('drink_test.jpg').open, filename: 'drink_test.jpg')

    login_as owner
    visit drink_path drink
    click_on 'Editar bebida'
    fill_in 'Nome', with: 'Cerveja da casa'
    fill_in 'Descrição', with: 'artesanal'
    fill_in 'Quantidade de calorias', with: '100'
    attach_file 'Imagem ilustrativa', file_fixture('drink2_test.jpg')
    check 'Alcoólica'
    click_on 'Salvar'

    expect(current_path).to eq drink_path(drink)
    expect(page).to have_content 'Bebida atualizada com sucesso'
    expect(page).to have_content 'Cerveja da casa'
    expect(page).to have_css "img[src*='drink2_test.jpg']"
    expect(page).to have_content 'artesanal'
    expect(page).to have_content 'Valor energético: 100 kcal'
    expect(page).to have_content 'Contém álcool'
  end

  it 'do seu próprio restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                          password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                            password: '123456789012')
    other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                        cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                        phone: '2736910853', email: 'paodelo@email.com')
    other_drink = other_restaurant.drinks.create!(name: 'Suco de limão', alcoholic: false, description: 'Geladinho')

    login_as owner
    visit edit_drink_path(other_drink)

    expect(current_path).to eq restaurant_path
  end

  it 'e remove campo obrigatório' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)

    login_as owner
    visit edit_drink_path(drink)
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Bebida não atualizada'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'e volta à tela de detalhes' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)

    login_as owner
    visit edit_drink_path drink
    click_on 'Voltar'

    expect(current_path).to eq drink_path(drink)
  end
end
