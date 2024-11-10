owner = Owner.create!(cpf: '34423090007', name: 'Paula', surname: 'Groselha', email: 'paula@email.com',
                              password: '123456789012')
restaurant = owner.create_restaurant!(brand_name: 'A Figueira Rubista', corporate_name: 'Figueira Rubista LTDA',
                        cnpj: '25401196000157', full_address: 'Rua das Flores, 10', phone: '1525017617',
                        email: 'afigueira@email.com')

restaurant.schedules.create!(active: true, weekday: "monday", start_time: '08:00', end_time: '17:00')
restaurant.schedules.create!(active: true, weekday: "friday", start_time: '10:00', end_time: '19:00')

dish = restaurant.dishes.create!(name: 'Provoleta de Cabra grelhada', description: 'Entrada', calories: 400, status: 'active')

dish.portions.create!(description: 'Porção pequena', price: 3_000)
dish.portions.create!(description: 'Porção jumbo', price: 5_000)

dish.dish_tags.create!(description: 'vegetariano')
dish.dish_tags.create!(description: 'derivado de leite')

drink = restaurant.drinks.create!(name: 'Coca-cola', alcoholic: false, description: 'Só uma Coca-cola', calories: 85,
                              status: 'active')
drink.portions.create!(description: 'Lata (350ml)', price: 800)
drink.portions.create!(description: 'Garrafa (1 litro)', price: 1200 )
