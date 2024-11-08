require 'rails_helper'

describe 'Usuário registra horário de funcionamento de restaurante' do
  it 'se estiver autenticado' do
    post schedules_path

    expect(response).to redirect_to new_owner_session_path
  end

  it 'e tem acesso a formulário se estiver autenticado' do
    get new_schedule_path

    expect(response).to redirect_to new_owner_session_path
  end

  it 'se tiver restaurante cadastrado' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    login_as owner
    post schedules_path

    expect(response).to redirect_to new_restaurant_path
  end

  it 'e tem acesso a formulário se tiver restaurante cadastrado' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    login_as owner
    get new_schedule_path

    expect(response).to redirect_to new_restaurant_path
  end
end
