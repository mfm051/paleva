require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe '#valid?' do
    context 'quando horário de fechamento é anterior ao de abertura' do
      it 'retorna falso' do
        schedule = Schedule.new(start_time: '08:00', end_time: '05:00')

        schedule.valid?

        expect(schedule.errors[:end_time]).to include 'deve ser posterior ao de abertura'
      end
    end

    context 'quando horário de fechamento é igual ao de abertura' do
      it 'retorna falso' do
        schedule = Schedule.new(start_time: '08:00', end_time: '08:00')

        schedule.valid?

        expect(schedule.errors[:end_time]).to include 'deve ser posterior ao de abertura'
      end
    end

    context 'quando já existe horário cadastrado para o restaurante no mesmo dia' do
      context 'quando horário está ativo' do
        it 'retorna falso' do
          owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                                    password: '123456789012')
          restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                  cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                  email: 'afigueira@email.com')
          restaurant.schedules.create!(active: true, weekday: "monday", start_time: '08:00', end_time: '17:00')
          schedule = restaurant.schedules.build(weekday: "monday")

          schedule.valid?

          expect(schedule.errors[:weekday]).to include 'já cadastrado para o restaurante'
        end
      end

      context 'quando horário está inativo' do
        it 'retorna verdadeiro' do
          owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                                    password: '123456789012')
          restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                                  cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                                  email: 'afigueira@email.com')
          restaurant.schedules.create!(active: false, weekday: "monday", start_time: '08:00', end_time: '17:00')
          schedule = restaurant.schedules.build(weekday: "monday")

          schedule.valid?

          expect(schedule.errors[:weekday]).not_to include 'já cadastrado para o restaurante'
        end
      end

      context 'quando não há horário de abertura' do
        it 'retorna falso' do
          schedule = Schedule.new(start_time: '')

          schedule.valid?

          expect(schedule.errors[:start_time]).to include 'não pode ficar em branco'
        end
      end

      context 'quando não há horário de fechamento' do
        it 'retorna falso' do
          schedule = Schedule.new(end_time: '')

          schedule.valid?

          expect(schedule.errors[:end_time]).to include 'não pode ficar em branco'
        end
      end

      context 'quando não há dia da semana' do
        it 'retorna falso' do
          schedule = Schedule.new(weekday: '')

          schedule.valid?

          expect(schedule.errors[:weekday]).to include 'não pode ficar em branco'
        end
      end
    end
  end
end
