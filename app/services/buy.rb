class Buy

  def self.buy_product(product_and_amount, current_user)
  	result = {success: false, msg: []}
    self.valid_product(product_and_amount[:product_id], result)
    return result if result[:msg].any?
    self.valid_amount_of_products(product_and_amount[:amount_of_products], result)
    return result if result[:msg].any?

    self.valid_quantity(result)
    return result if result[:msg].any?

    self.perform_cal(current_user, result)
    result
  end	

  def self.valid_product(product_id, result)
  	@product = Product.find_by_id(product_id)
  	result[:msg].push("Product not found, please provide valid product id") unless @product
  end

  def self.valid_amount_of_products(quantity, result)
    @amount_of_products = quantity.to_i
    if @amount_of_products == 0 || @amount_of_products < 0 
    	result[:msg].push("Amount of products must be an integer value")
    end
  end

  def self.valid_quantity(result)
  	if @product.amountAvailable < @amount_of_products || @product.amountAvailable <= 0 
      result[:msg].push("Avilable quantity of product is less the requested quantity") 
    end
  end

  def self.perform_cal(current_user, result)
  	spend_amount = @product.cost * @amount_of_products
    available_cents = current_user.deposit
    result[:msg].push("Insufficinet amount please reduce the amount_of_products or deposit more fund") if spend_amount > available_cents
    return result if result[:msg].any?
    remaining_amount = available_cents - spend_amount
    remaining_quantity = @product.amountAvailable - @amount_of_products
    current_user.update_attribute(:deposit, remaining_amount)
    @product.update_attribute(:amountAvailable, remaining_quantity)
    result[:success] = true
    result[:msg].push({total_spend_amount: spend_amount, product: @product, remaining_amount: remaining_amount})
    result
  end
end