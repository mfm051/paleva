require 'rails_helper'

RSpec.describe Drink, type: :model do
  describe '#valid?' do
    context 'Quando algum campo é nulo' do
      it 'retorna falso para nome' do
        drink = Drink.new(name: '')

        drink.valid?

        expect(drink.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para descrição' do
        drink = Drink.new(description: '')

        drink.valid?

        expect(drink.errors[:description]).to include 'não pode ficar em branco'
      end

      it 'retorna verdadeiro para quantidade de calorias' do
        drink = Drink.new(calories: nil)

        drink.valid?

        expect(drink.errors[:calories]).not_to include 'não pode ficar em branco'
      end
    end

    context 'quando alcoólico não é booleano' do
      it 'retorna falso para alcoólico' do
        drink = Drink.new(alcoholic: nil)

        drink.valid?

        expect(drink.errors[:alcoholic]).to include 'não está incluído na lista'
      end
    end

    context 'Quando nome já está em uso' do
      it 'retorna falso' do
        owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
        restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                email: 'afigueira@email.com')
        restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola')

        drink = Drink.new(name: 'Coca-cola')

        drink.valid?

        expect(drink.errors[:name]).to include 'já está em uso'
      end
    end
  end
end
