require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe '#valid?' do
    context 'quando campo está ausente' do
      it 'retorna falso para email' do
        owner = Owner.new(email: '')

        owner.valid?

        expect(owner.errors[:email]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para senha' do
        owner = Owner.new(password: '')

        owner.valid?

        expect(owner.errors[:password]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para cpf' do
        owner = Owner.new(cpf: '')

        owner.valid?

        expect(owner.errors[:cpf]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para nome' do
        owner = Owner.new(name: '')

        owner.valid?

        expect(owner.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para sobrenome' do
        owner = Owner.new(surname: '')

        owner.valid?

        expect(owner.errors[:surname]).to include 'não pode ficar em branco'
      end
    end

    context 'quando a senha é menor que 12 caracteres' do
      it 'retorna falso' do
        owner = Owner.new(password: 'onzecaracte')

        owner.valid?

        expect(owner.errors[:password]).to include 'é muito curto (mínimo: 12 caracteres)'
      end
    end

    context 'quando CPF não tem 11 caracteres' do
      it 'retorna falso para valor muito curto' do
        owner = Owner.new(cpf: '123456')

        owner.valid?

        expect(owner.errors[:cpf]).to include 'deve ter 11 caracteres'
      end

      it 'retorna falso para valor muito longo' do
        owner = Owner.new(cpf: '12345678910111213')

        owner.valid?

        expect(owner.errors[:cpf]).to include 'deve ter 11 caracteres'
      end
    end

    context 'quando CPF não é composto apenas por números' do
      it 'retorna falso' do
        owner = Owner.new(cpf: 'ABC91409020')

        owner.valid?

        expect(owner.errors[:cpf]).to include 'deve ser composto apenas por números'
      end
    end

    context 'quando CPF não é válido' do
      it 'retorna falso' do
        owner = Owner.new(cpf: '00000000000')

        owner.valid?

        expect(owner.errors[:cpf]).to include 'não é válido'
      end
    end

    context 'quando e-mail não é valido' do
      it 'retorna falso para email sem local' do
        owner = Owner.new(email: '@email.com')

        owner.valid?

        expect(owner.errors[:email]).to include 'não é válido'
      end

      it 'retorna falso para email sem domínio' do
        owner = Owner.new(email: 'local@')

        owner.valid?

        expect(owner.errors[:email]).to include 'não é válido'
      end
    end
  end
end
