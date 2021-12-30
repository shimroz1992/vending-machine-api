class ProductsController < ApplicationController
  before_action :authorize_request, except: [:index]
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :check_seller, only: [:create, :update, :destroy]
  before_action :check_buyer, only: [:buy, :deposit, :reset]
  before_action :valid_buyer_params, only: [:buy]

  # GET /products
  def index
    @products = Product.all
    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  def deposit
    if @current_user.valid_cent_coin(params["coin"]) && @current_user.save
      render json: @current_user.to_json, status: :ok
    else
      render json: @current_user.errors, status: :unprocessable_entity
    end
  end

  def buy
    result = Buy.buy_product(buyer_params, @current_user)
    if result[:success]
      render json: result, status: :ok
    else
      render json: result, status: :unprocessable_entity
    end
  end

  def reset
    if @current_user.update(deposit: 0)
      render json: @current_user
    else
      render json: @current_user, status: :unprocessable_entity
    end
  end

  # POST /products
  def create
    @product = @current_user.products.new(product_params)
    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = @current_user.products.find(params[:id])
      rescue ActiveRecord::RecordNotFound
      render json: { errors: 'product not found' }, status: :not_found
    end

    def check_seller
      unless @current_user.seller?
        return render json: {message: 'User must be seller to create update and destroy the product.'}, status: :unprocessable_entity
      end
    end

    def check_buyer
      unless @current_user.buyer?
        return render json: {message: 'User must be buyer to buy the product.'}, status: :unprocessable_entity
      end
    end

    def valid_buyer_params
      unless buyer_params["product_id"] || buyer_params["amount_of_products"]
        return render json: {message: 'Please provide valid product_id and amount_of_products'}, status: :unprocessable_entity
      end
    end
    # Only allow a trusted parameter "white list" through.
    def product_params
      params.permit(:amountAvailable, :cost, :productName)
    end

    def buyer_params
      params.permit(:product_id, :amount_of_products)
    end
end
