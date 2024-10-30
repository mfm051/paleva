require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe '#valid?' do
    it 'cria código de 6 caracteres automaticamente' do
      restaurant = Restaurant.new

      restaurant.valid?

      expect(restaurant.code.length).to eq 6
    end

    context 'quando algum campo está em branco' do
      it 'retorna falso para nome fantasia' do
        restaurant = Restaurant.new(brand_name: '')

        restaurant.valid?

        expect(restaurant.errors[:brand_name]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para razão social' do
        restaurant = Restaurant.new(corporate_name: '')

        restaurant.valid?

        expect(restaurant.errors[:corporate_name]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para CNPJ' do
        restaurant = Restaurant.new(cnpj: '')

        restaurant.valid?

        expect(restaurant.errors[:cnpj]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para endereço' do
        restaurant = Restaurant.new(full_address: '')

        restaurant.valid?

        expect(restaurant.errors[:full_address]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para telefone' do
        restaurant = Restaurant.new(phone: '')

        restaurant.valid?

        expect(restaurant.errors[:phone]).to include 'não pode ficar em branco'
      end

      it 'retorna falso para e-mail' do
        restaurant = Restaurant.new(email: '')

        restaurant.valid?

        expect(restaurant.errors[:email]).to include 'não pode ficar em branco'
      end
    end

    context 'quando email é inválido' do
      it 'retorna falso para email sem local' do
        restaurant = Restaurant.new(email: '@email.com')

        restaurant.valid?

        expect(restaurant.errors[:email]).to include 'não é válido'
      end

      it 'retorna falso para email sem domínio' do
        restaurant = Restaurant.new(email: 'local@')

        restaurant.valid?

        expect(restaurant.errors[:email]).to include 'não é válido'
      end
    end

    context 'quando CNPJ é inválido' do
      it 'retorna falso para valor muito curto' do
        restaurant = Restaurant.new(cnpj: '2540119600015')

        restaurant.valid?

        expect(restaurant.errors[:cnpj]).to include 'não possui o tamanho esperado (14 caracteres)'
      end

      it 'retorna falso para valor muito longo' do
        restaurant = Restaurant.new(cnpj: '254011960001570')

        restaurant.valid?

        expect(restaurant.errors[:cnpj]).to include 'não possui o tamanho esperado (14 caracteres)'
      end

      it 'retorna falso para valores não numéricos' do
        restaurant = Restaurant.new(cnpj: 'ABC01196000157')

        restaurant.valid?

        expect(restaurant.errors[:cnpj]).to include 'deve ser composto apenas por números'
      end

      it 'retorna falso para valor que não atende às regras' do
        restaurant = Restaurant.new(cnpj: '00000000000000')

        restaurant.valid?

        expect(restaurant.errors[:cnpj]).to include 'não é válido'
      end
    end

    context 'quando campo é duplicado' do
      it 'retorna falso para razão social' do
        owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
        Restaurant.create!(corporate_name: 'Figueira Rubista LTDA', cnpj: '25401196000157', owner: owner,
                            brand_name: 'A Figueira Rubista', full_address: 'Rua das Flores, 10',
                            phone: '1525017617', email: 'afigueira@email.com')
        restaurant = Restaurant.new(corporate_name: 'Figueira Rubista LTDA')

        restaurant.valid?

        expect(restaurant.errors[:corporate_name]).to include 'já está em uso'
      end

      it 'retorna falso para cnpj' do
        owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
        Restaurant.create!(cnpj: '25401196000157', owner: owner, brand_name: 'A Figueira Rubista',
                            corporate_name: 'Figueira Rubista LTDA', full_address: 'Rua das Flores, 10',
                            phone: '1525017617', email: 'afigueira@email.com')
        restaurant = Restaurant.new(cnpj: '25401196000157')

        restaurant.valid?

        expect(restaurant.errors[:cnpj]).to include 'já está em uso'
      end

      it 'retorna falso para endereço' do
        owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
        Restaurant.create!(full_address: 'Rua das Flores, 10', cnpj: '25401196000157', owner: owner,
                            brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                            phone: '1525017617', email: 'afigueira@email.com')
        restaurant = Restaurant.new(full_address: 'Rua das Flores, 10')

        restaurant.valid?

        expect(restaurant.errors[:full_address]).to include 'já está em uso'
      end

      it 'retorna falso para código' do
        owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
        previous_restaurant = Restaurant.create!(cnpj: '25401196000157', owner: owner, brand_name: 'A Figueira Rubista',
                            corporate_name: 'Figueira Rubista LTDA', full_address: 'Rua das Flores, 10',
                            phone: '1525017617', email: 'afigueira@email.com')

        restaurant = Restaurant.new
        allow(SecureRandom).to receive(:alphanumeric).and_return previous_restaurant.code

        restaurant.valid?

        expect(restaurant.errors[:code]).to include 'já está em uso'
      end
    end

    context 'quando telefone é inválido' do
      it 'retorna falso para valor com menos de 10 caracteres' do
        restaurant = Restaurant.new(phone: '123456789')

        restaurant.valid?

        expect(restaurant.errors[:phone]).to include 'é muito curto (mínimo: 10 caracteres)'
      end

      it 'retorna falso para valor com mais de 11 caracteres' do
        restaurant = Restaurant.new(phone: '123456789111')

        restaurant.valid?

        expect(restaurant.errors[:phone]).to include 'é muito longo (máximo: 11 caracteres)'
      end

      it 'retorna falso para valor não numérico' do
        restaurant = Restaurant.new(phone: '1234567891A')

        restaurant.valid?

        expect(restaurant.errors[:phone]).to include 'deve ser composto apenas por números'
      end
    end
  end
end
