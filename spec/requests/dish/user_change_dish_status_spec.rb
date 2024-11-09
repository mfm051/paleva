require 'rails_helper'

describe 'Usuário muda status de prato' do
  context 'para inativo' do
    it 'se estiver logado' do
      fake_dish_id = 1

      patch deactivate_dish_path(fake_dish_id)

      expect(response).to redirect_to new_owner_session_path
    end

    it 'se tiver restaurante' do
      owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
      fake_dish_id = 1

      login_as owner
      patch deactivate_dish_path(fake_dish_id)

      expect(response).to redirect_to new_restaurant_path
    end

    it 'do seu próprio restaurante' do
      other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
      other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                              cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                              phone: '2736910853', email: 'paodelo@email.com')
      other_dish = other_restaurant.dishes.create!(status: 'active', name: 'Torteletes de limão',
                                                    description: 'Sobremesa azedinha')

      owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                            password: '123456789012')
      restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')

      login_as owner
      patch deactivate_dish_path(other_dish)

      expect(other_restaurant.dishes.last.status).to eq 'active'
      expect(response).to redirect_to restaurant
    end
  end

  context 'para ativo' do
    it 'se estiver logado' do
      fake_dish_id = 1

      patch activate_dish_path(fake_dish_id)

      expect(response).to redirect_to new_owner_session_path
    end

    it 'se tiver restaurante' do
      owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
      fake_dish_id = 1

      login_as owner
      patch activate_dish_path(fake_dish_id)

      expect(response).to redirect_to new_restaurant_path
    end

    it 'do seu próprio restaurante' do
      other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
      other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                              cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                              phone: '2736910853', email: 'paodelo@email.com')
      other_dish = other_restaurant.dishes.create!(status: 'inactive', name: 'Torteletes de limão',
                                                    description: 'Sobremesa azedinha')

      owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                            password: '123456789012')
      restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                          cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                          email: 'afigueira@email.com')

      login_as owner
      patch activate_dish_path(other_dish)

      expect(other_restaurant.dishes.last.status).to eq 'inactive'
      expect(response).to redirect_to restaurant
    end
  end
end
