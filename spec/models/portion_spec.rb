require 'rails_helper'

RSpec.describe Portion, type: :model do
  describe '#valid?' do
    context 'quando descrição é vazia' do
      it 'retorna falso' do
        portion = Portion.new(description: '')

        portion.valid?

        expect(portion.errors[:description]).to include 'não pode ficar em branco'
      end
    end

    context 'quando preço é vazio' do
      it 'retorna falso' do
        portion = Portion.new(price: nil)

        portion.valid?

        expect(portion.errors[:price]).to include 'não pode ficar em branco'
      end
    end

    context 'quando preço não é inteiro' do
      it 'retorna falso' do
        portion = Portion.new(price: 'barato')

        portion.valid?

        expect(portion.errors[:price]).to include 'não é um número'
      end
    end

    context 'quando preço é negativo' do
      it 'retorna falso' do
        portion = Portion.new(price: -1)

        portion.valid?

        expect(portion.errors[:price]).to include 'deve ser maior que 0'
      end
    end

    context 'quando preço é igual a zero' do
      it 'retorna falso' do
        portion = Portion.new(price: 0)

        portion.valid?

        expect(portion.errors[:price]).to include 'deve ser maior que 0'
      end
    end

    context 'quando preço é maior que zero' do
      it 'retorna verdadeiro' do
        portion = Portion.new(price: 1)

        portion.valid?

        expect(portion.errors[:price]).not_to include 'deve ser maior que 0'
      end
    end
  end
end
