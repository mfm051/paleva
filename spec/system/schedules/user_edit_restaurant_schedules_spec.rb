require 'rails_helper'

describe 'Dono edita horários de funcionamento' do
  it 'a partir da tela do restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')
    restaurant.schedules.create!(weekday: "monday", start_time: '08:00', end_time: '17:00')
    restaurant.schedules.create!(weekday: "tuesday", start_time: '08:00', end_time: '17:00')
    restaurant.schedules.create!(weekday: "wednesday", start_time: '08:00', end_time: '17:00')

    login_as owner
    visit restaurant_path
    click_on 'Editar horários de funcionamento'
    within '#monday' do
      uncheck 'Aberto'
    end
    within '#tuesday' do
      fill_in 'Horário de abertura', with: '07:00'
    end
    click_on 'Salvar'

    expect(current_path).to eq restaurant_path
    expect(page).not_to have_content 'Segunda-feira'
    expect(page).to have_content 'Terça-feira: das 07:00 às 17:00'
    expect(page).to have_content 'Quarta-feira: das 08:00 às 17:00'
  end
end
