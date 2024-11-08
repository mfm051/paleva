require 'rails_helper'

describe 'Usuário edita horários de funcionamento do restaurate' do
  it 'se estiver autenticado' do
    patch schedules_path

    expect(response).to redirect_to new_owner_session_path
  end

  it 'e tem acesso a formulário de edição se estiver autenticado' do
    get edit_schedules_path

    expect(response).to redirect_to new_owner_session_path
  end

  it 'se tiver restaurante cadastrado' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    login_as owner
    patch schedules_path

    expect(response).to redirect_to new_restaurant_path
  end

  it 'e tem acesso a formulário de edição se tiver restaurante cadastrado' do
    owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')

    login_as owner
    get edit_schedules_path

    expect(response).to redirect_to new_restaurant_path
  end
end
