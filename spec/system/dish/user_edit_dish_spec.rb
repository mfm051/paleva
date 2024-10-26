require 'rails_helper'

describe 'Usuário edita prato' do
  it 'a partir da tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)
    dish.illustration.attach(io: file_fixture('dish_test.jpg').open, filename: 'dish_test.jpg')

    login_as owner
    visit root_path
    click_on 'Provoleta de Cabra grelhada'
    fill_in 'Nome', with: 'Provoleta de Cabra assada'
    fill_in 'Descrição', with: 'Prato principal leve'
    fill_in 'Quantidade de calorias', with: '450'
    attach_file 'Imagem ilustrativa', file_fixture('dish2_test.jpg')
    click_on 'Salvar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Prato atualizado com sucesso'
    expect(page).to have_content 'Provoleta de Cabra assada'
    expect(page).to have_content 'Prato principal leve'
    expect(page).to have_content 'Valor energético: 450 kcal'
    expect(page).to have_css "img[src*='dish2_test.jpg']"
  end

  it 'e remove campo obrigatório' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)

    login_as owner
    visit root_path
    click_on 'Provoleta de Cabra grelhada'
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Prato não atualizado'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'e volta à tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400)

    login_as owner
    visit root_path
    click_on 'Provoleta de Cabra grelhada'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
