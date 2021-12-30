# README


* Ruby version: ruby-2.6.5, rails 6

* Setup the project with following command 

  1. Clone the project with git clone

  2. bundle install

  3. rake db:setup to run rake db:create,rake db:migrate and rake db:seed 

  4. rails s to start the server

  5. rake test to run all test cases

I have added buyer and seller user in seed.rb file, and two products as well so when we do seed the user and products will be created.


* Api with path and function

  * Create user

    * POST localhost:3000/users with params username, password and role which buyer or seller

      EX: curl --location --request
          POST 'localhost:3000/users' \
          --form 'username="test"' \
          --form 'password="12345678"' \
          --form 'role="buyer"'

  * Get token

    * POST localhost:3000/login with params username, password 
      
      EX: curl --location --request 
          POST 'localhost:3000/login?username=test_buyer&password=12345678'


  * Create Product

    * POST localhost:3000/products to create product but user must be seller to create product, pass following param to creat product

      EX: curl --location --request POST 'localhost:3000/products' \
          --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0LCJleHAiOjE2NDA5NDU0ODR9.Mj0hDcZrwHqWnLRTBwGgAvVkClGCPUQEjZEcl2k_zWI' \
          --form 'amountAvailable="100"' \
          --form 'cost="500"' \
          --form 'productName="test"'


  * Deposit fund

    * POST localhost:3000/deposit user must be buyer to deposit fund  coin must be 5,10,20,50 or 100

      EX: curl --location --request POST 'localhost:3000/deposit' \
          --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDA3ODkyMTh9.cTifQsE8DpVp5b2RJDhUMoryn75ASkOtXR1DvALHM5Q' \
          --form 'coin="100"'

  * Buy Product

    * POST localhost:3000/buy buy product with product id and number of amount_of_products(quantity)


      EX: curl --location --request POST 'localhost:3000/buy' \
          --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDA5NDUzNDh9._ekHy7YZyaQz-CTI7j1h4MuXHrDrdVjbe_vByqSY298' \
          --form 'product_id="1"' \
          --form 'amount_of_products="1"'

      Response: 

        {
          "success": true,
          "msg": [
              {
                  "total_spend_amount": 100,
                  "product": {
                      "amountAvailable": 66,
                      "cost": 100,
                      "id": 1,
                      "productName": "first_product",
                      "user_id": 2,
                      "created_at": "2021-12-30T08:57:57.619Z",
                      "updated_at": "2021-12-30T10:18:54.181Z"
                  },
                  "remaining_amount": 0
              }
          ]
       }


  * Reset deposit to zero 

    * POST localhost:3000/reset reset deposit to zero for buyer

      EX: curl --location --request POST 'localhost:3000/reset' \
          --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDA3ODkyMTh9.cTifQsE8DpVp5b2RJDhUMoryn75ASkOtXR1DvALHM5Q'

  * Logout all sessions

    * POST localhost:3000/logout/all logout all sessions

      EX: curl --location --request POST 'localhost:3000/logout/all' \
          --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NDA4NzMzMjR9.X7FkSb7beu1fVYY48kDEEFOtwoaOYrll9rWWduImjis'


Note: I have also added postman collection with the project please have a  look on file vending-machine-api.postman_collection.json
