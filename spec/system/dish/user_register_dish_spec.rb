require 'rails_helper'

describe 'Usuário registra um prato para seu estabelecimento' do
  it 'a partir da tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path
    click_on 'Novo prato'
    fill_in 'Nome', with: 'Provoleta de Cabra grelhada'
    fill_in 'Descrição', with: 'Entrada'
    fill_in 'Quantidade de calorias', with: '100'
    attach_file 'Imagem ilustrativa', file_fixture('dish_test.jpg')
    within "input[name*='[dish_tags_attributes][0]']" do
      fill_in with: 'derivado de leite'
    end
    within "input[name*='[dish_tags_attributes][1]']" do
      fill_in with: 'vegetariano'
    end
    click_on 'Salvar'

    expect(current_path).to eq dish_path(restaurant.dishes.last)
    expect(page).to have_content 'Prato cadastrado com sucesso'
    expect(page).to have_content 'Provoleta de Cabra grelhada'
    expect(page).to have_content 'Entrada'
    expect(page).to have_content 'Valor energético: 100 kcal'
    expect(page).to have_css "img[src*='dish_test.jpg']"
    expect(page).to have_content 'Marcadores:'
    expect(page).to have_content 'derivado de leite'
    expect(page).to have_content 'vegetariano'
    page.assert_selector('li.dish_tag', count: 2)
  end

  it 'e adiciona marcador já existente para outro prato' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    other_dish = restaurant.dishes.create!(name: 'Feijoada', description: 'Prato principal', calories: 400,
                            status: 'active')
    other_dish.dish_tags.create!(description: 'salgado')

    login_as owner
    visit new_dish_path
    fill_in 'Nome', with: 'Provoleta de Cabra grelhada'
    fill_in 'Descrição', with: 'Entrada'
    fill_in 'Quantidade de calorias', with: '100'
    within "input[name*='[dish_tags_attributes][0]']" do
      fill_in with: 'salgado'
    end
    click_on 'Salvar'

    expect(page).to have_content 'Marcadores:'
    expect(page).to have_content 'salgado'
    page.assert_selector('li.dish_tag', text: 'salgado', count: 1)
  end

  it 'e não preeche campo corretamente' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit new_dish_path
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Prato não cadastrado'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'e volta à tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path
    click_on 'Novo prato'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
