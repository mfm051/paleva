require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe 'antes de salvar' do
    it 'verifica se marcadores adicionados já existem antes de criá-los' do
      owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
      restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                            cnpj: '25401196000157', full_address: 'Rua das Flores, 10',
                                            phone: '1525017617', email: 'afigueira@email.com')

      dish_tag = DishTag.create!(description: 'vegetariano')
      dish = restaurant.dishes.new(name: 'Provoleta de Cabra grelhada', description: 'Entrada',
                                  dish_tags_attributes: [description: 'vegetariano'])

      dish.save!

      expect(dish.dish_tags).to include dish_tag
    end
  end
  describe '#valid?' do
    context 'Quando algum campo é nulo' do
      it 'retorna falso para nome' do
        dish = Dish.new(name: '')

        dish.valid?

        expect(dish.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para descrição' do
        dish = Dish.new(description: '')

        dish.valid?

        expect(dish.errors[:description]).to include 'não pode ficar em branco'
      end

      it 'retorna verdadeiro para quantidade de calorias' do
        dish = Dish.new(calories: '')

        dish.valid?

        expect(dish.errors[:calories]).not_to include 'não pode ficar em branco'
      end
    end

    context 'quando nome já está cadastrado' do
      it 'retorna falso' do
        owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
        restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                              cnpj: '25401196000157', full_address: 'Rua das Flores, 10',
                                              phone: '1525017617', email: 'afigueira@email.com')
        restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada')

        dish = Dish.new(name: 'Provoleta de Cabra grelhada')

        dish.valid?

        expect(dish.errors[:name]).to include 'já está em uso'
      end
    end
  end
end
