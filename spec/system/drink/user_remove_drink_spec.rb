require 'rails_helper'

describe 'Usuário remove uma bebida do seu estabelecimento' do
  it 'com sucesso' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85)
    restaurant.drinks.create!(name: 'Mistério', alcoholic: true, description: 'Vermouth Dourado infusionado'\
                                      ' com grãos de café, Bacardi 8 anos, licor Grand Marnier e Bitter Aromatic.')

    login_as(owner)
    visit root_path
    click_on 'Coca-cola'
    click_on 'Remover bebida'

    expect(page).to have_content 'Bebida removida com sucesso'
    expect(page).not_to have_content 'Coca-cola'
    expect(page).to have_content 'Mistério'
  end
end
