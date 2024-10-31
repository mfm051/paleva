require 'rails_helper'

describe 'Usuário vê detalhes de seu restaurante' do
  it 'a partir da tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path
    within 'nav' do
      click_on 'Informações do restaurante'
    end

    expect(page).to have_content 'A Figueira Rubista'
    expect(page).to have_content 'Figueira Rubista LTDA'
    expect(page).to have_content "Código: #{restaurant.code}"
    expect(page).to have_content 'CNPJ: 25401196000157'
    expect(page).to have_content 'Endereço: Rua das Flores, 10'
    expect(page).to have_content 'Telefone: 1525017617'
    expect(page).to have_content 'afigueira@email.com'
  end

  it 'E volta à tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit root_path
    within 'nav' do
      click_on 'Informações do restaurante'
    end
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
