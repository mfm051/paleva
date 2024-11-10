require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#valid?' do
    it 'retorna falso se nome é vazio' do
      menu = Menu.new(name: '')

      menu.valid?

      expect(menu.errors[:name]).to include 'não pode ficar em branco'
    end

    context 'quando não contem nenhum item' do
      it 'retorna falso' do
        menu = Menu.new(name: 'Executivo')

        menu.valid?

        expect(menu.errors[:base]).to include 'deve conter ao menos um item'
      end

      it 'retorna verdadeiro se há uma bebida' do
        owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
        restaurant = Restaurant.create!(corporate_name: 'Figueira Rubista LTDA', cnpj: '25401196000157', owner: owner,
                                        brand_name: 'A Figueira Rubista', full_address: 'Rua das Flores, 10',
                                        phone: '1525017617', email: 'afigueira@email.com')
        drink = restaurant.drinks.create!(name: 'Suco de limão', description: 'Também conhecido como limonada',
                                          alcoholic: false)

        menu = restaurant.menus.build(name: 'Executivo')
        menu.drinks << drink

        menu.valid?

        expect(menu.errors[:base]).not_to include 'deve conter ao menos um item'
      end

      it 'retorna verdadeiro se há um prato' do
        owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
        restaurant = Restaurant.create!(corporate_name: 'Figueira Rubista LTDA', cnpj: '25401196000157', owner: owner,
                                        brand_name: 'A Figueira Rubista', full_address: 'Rua das Flores, 10',
                                        phone: '1525017617', email: 'afigueira@email.com')
        dish = restaurant.dishes.create!(name: 'Tortinhas de limão', description: 'Sobremesa')

        menu = restaurant.menus.build(name: 'Executivo')
        menu.dishes << dish

        menu.valid?

        expect(menu.errors[:base]).not_to include 'deve conter ao menos um item'
      end
    end

    context 'quando já existe outro menu com o mesmo nome cadastrado' do
      context 'no mesmo restaurante' do
        it 'retorna falso' do
          owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
          restaurant = Restaurant.create!(corporate_name: 'Figueira Rubista LTDA', cnpj: '25401196000157', owner: owner,
                                          brand_name: 'A Figueira Rubista', full_address: 'Rua das Flores, 10',
                                          phone: '1525017617', email: 'afigueira@email.com')
          dish = restaurant.dishes.create!(name: 'Tortinhas de limão', description: 'Sobremesa')
          restaurant.menus.create!(name: 'Executivo', dishes: [dish])

          menu = restaurant.menus.build(name: 'Executivo')

          menu.valid?

          expect(menu.errors[:name]).to include 'já está em uso'
        end
      end

      context 'em outro restaurante' do
        it 'retorna verdadeiro' do
          other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
          other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                            cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                            phone: '2736910853', email: 'paodelo@email.com')
          other_dish = other_restaurant.dishes.create!(name: 'Tortinhas de limão', description: 'Sobremesa')
          other_restaurant.menus.create!(name: 'Executivo', dishes: [other_dish])

          owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
          restaurant = Restaurant.create!(corporate_name: 'Figueira Rubista LTDA', cnpj: '25401196000157', owner: owner,
                                          brand_name: 'A Figueira Rubista', full_address: 'Rua das Flores, 10',
                                          phone: '1525017617', email: 'afigueira@email.com')

          menu = restaurant.menus.build(name: 'Executivo')

          menu.valid?

          expect(menu.errors[:name]).not_to include 'já está em uso'
        end
      end
    end

    context 'quando prato adicionado pertence a outro restaurante' do
      it 'retorna falso' do
        other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
        other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                          cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                          phone: '2736910853', email: 'paodelo@email.com')
        other_dish = other_restaurant.dishes.create!(name: 'Tortinhas de limão', description: 'Sobremesa')

        owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                            password: '123456789012')
        restaurant = Restaurant.create!(corporate_name: 'Figueira Rubista LTDA', cnpj: '25401196000157', owner: owner,
                                        brand_name: 'A Figueira Rubista', full_address: 'Rua das Flores, 10',
                                        phone: '1525017617', email: 'afigueira@email.com')

        menu = restaurant.menus.build(dishes: [other_dish])

        menu.valid?

        expect(menu.errors[:dish]).to include 'deve pertencer ao restaurante do cardápio'
      end
    end

    context 'quando bebida adicionada pertence a outro restaurante' do
      it 'retorna falso' do
        other_owner = Owner.create!(cpf: '58536236051', name: 'Érico', surname: 'Jacan', email: 'erico@email.com',
                                password: '123456789012')
        other_restaurant = other_owner.create_restaurant!(brand_name: 'Pão-de-ló na Cozinha', corporate_name: 'Pão-de-Ló LTDA',
                                                          cnpj: '65309109000150', full_address: 'Rua Francesa, 15',
                                                          phone: '2736910853', email: 'paodelo@email.com')
        other_drink = other_restaurant.drinks.create!(name: 'Suco de uva', description: 'Integral', alcoholic: false)

        owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
        restaurant = Restaurant.create!(corporate_name: 'Figueira Rubista LTDA', cnpj: '25401196000157', owner: owner,
                                        brand_name: 'A Figueira Rubista', full_address: 'Rua das Flores, 10',
                                        phone: '1525017617', email: 'afigueira@email.com')
        menu = restaurant.menus.build(drinks: [other_drink])

        menu.valid?

        expect(menu.errors[:drink]).to include 'deve pertencer ao restaurante do cardápio'
      end
    end
  end
end
