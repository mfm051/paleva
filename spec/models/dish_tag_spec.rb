require 'rails_helper'

RSpec.describe DishTag, type: :model do
  describe 'converte descrição para caracteres minúsculos' do
    it 'antes da validação' do
      dish_tag = DishTag.new(description: 'Sem GLÚTEN')

      dish_tag.valid?

      expect(dish_tag.description).to eq 'sem glúten'
    end

    it 'se valor for atualizado' do
      dish_tag = DishTag.create!(description: 'sem glúten')

      dish_tag.update!(description: 'Sem Glúten')

      expect(dish_tag.description).to eq 'sem glúten'
    end
  end

  describe '#valid?' do
    context 'quando descrição já existe' do
      it 'retorna falso' do
        DishTag.create!(description: 'sem glúten')
        dish_tag = DishTag.new(description: 'sem glúten')

        dish_tag.valid?

        expect(dish_tag.errors[:description]).to include 'já está em uso'
      end
    end

    context 'quando descrição é nula' do
      it 'retorna falso' do
        dish_tag = DishTag.new(description: '')

        dish_tag.valid?

        expect(dish_tag.errors[:description]).to include 'não pode ficar em branco'
      end
    end
  end
end
