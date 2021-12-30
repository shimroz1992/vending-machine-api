# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


user_buyer = User.create(username: 'test_buyer', password: '12345678', role: 'buyer', deposit: 100)
user_seller = User.create(username: 'test_seller', password: '12345678', role: 'seller')

user_seller.products.create([
	                         {amountAvailable: 67, cost: 100, productName: 'first_product'},
	                         {amountAvailable: 100, cost: 200, productName: 'second_product'}
                            ])