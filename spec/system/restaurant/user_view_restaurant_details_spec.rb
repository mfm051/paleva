require 'rails_helper'

describe 'Usuário vê detalhes de seu restaurante' do
  it 'a partir da tela inicial' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    restaurant.schedules.create!(weekday: "monday", start_time: '08:00', end_time: '17:00')
    restaurant.schedules.create!(weekday: "friday", start_time: '10:00', end_time: '19:00')

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
    expect(page).to have_content 'Horários de funcionamento:'
    expect(page).to have_content 'Segunda-feira: das 08:00 às 17:00'
    expect(page).to have_content 'Sexta-feira: das 10:00 às 19:00'
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
