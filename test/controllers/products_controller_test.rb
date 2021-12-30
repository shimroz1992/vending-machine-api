require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    seller = users(:seller)
    @product = products(:one)
    @token = authenticated_header(seller)
    buyer = users(:buyer)
    @buyer_token = authenticated_header(buyer)
  end

  test "should get index" do
    get products_url, as: :json
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url,headers: @token, params: { amountAvailable: @product.amountAvailable, cost: @product.cost, productName: @product.productName, user_id: @product.user_id }, as: :json
    end

    assert_response 201
  end

  test "buyer should deposit" do
    post deposit_url, headers: @buyer_token, params: { coin: 5 }, as: :json
    assert_response 200
  end

  test "buyer should buy product" do
    post buy_url, headers: @buyer_token, params: { product_id: @product.id, amount_of_products: 2}, as: :json
    assert_response 200
  end

  test "should show product" do
    get product_url(@product),headers: @token, as: :json
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), headers: @token,params:  { amountAvailable: @product.amountAvailable, cost: @product.cost, productName: @product.productName, user_id: @product.user_id }, as: :json
    assert_response 200
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product), headers: @token, as: :json
    end

    assert_response 204
  end
end
