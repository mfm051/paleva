require 'rails_helper'

describe 'Dono registra horário de funcionamento do restaurante' do
  it 'a partir da tela de detalhes do restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit restaurant_path
    click_on 'Registrar novo horário de funcionamento'
    select 'Segunda-feira', from: 'Dia da semana'
    fill_in 'Horário de abertura', with: '08:00'
    fill_in 'Horário de fechamento', with: '17:00'
    click_on 'Salvar'

    expect(current_path).to eq restaurant_path
    expect(page).to have_content 'Horário registrado com sucesso'
    expect(page).to have_content 'Segunda-feira: das 08:00 às 17:00'
  end

  it 'e fornece dados incorretos' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit new_schedule_path
    select 'Segunda-feira', from: 'Dia da semana'
    fill_in 'Horário de abertura', with: '17:00'
    fill_in 'Horário de fechamento', with: '08:00'
    click_on 'Salvar'

    expect(page).to have_content 'Horário não registrado'
    expect(page).to have_content 'Horário de fechamento deve ser posterior ao de abertura'
  end

  it 'e volta à tela do restaurante' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
    owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                            email: 'afigueira@email.com')

    login_as owner
    visit new_schedule_path
    click_on 'Voltar'

    expect(current_path).to eq restaurant_path
  end
end
