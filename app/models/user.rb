class User < ApplicationRecord
	enum role: [:seller, :buyer]
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :role, presence: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }	

  has_many :products
  has_many :jwt_tokens

  def valid_cent_coin(cents_val)
  	self.errors.add(:user, 'user must be buyer to deposit') if !self.buyer?
  	if valid_val?(cents_val)
  		self.deposit += cents_val.to_i
  	else
      self.errors.add(:deposit, 'coin value is not valid, valid coin values are 5,10,20,50,100')
  	end
  	!self.errors.any?
  end
 
  def valid_val?(cents_val)
  	[5,10,20,50,100].include?(cents_val&.to_i)  
  end


  def invalid_token?(token)
  	!jwt_tokens.where(token: token).present?
  end

  def get_change
    return 0 if self.deposit <= 0
    change = [100,50,20,10,5]
    coins = []
    amount = self.deposit
    i=0
    while amount != 0 && i <= (change.length - 1)
      while amount >= change[i]
         amount = amount - change[i]
         coins.push(change[i])
      end
      i+=1
    end
    if coins.empty? && amount > 0
      "No change found for amount #{amount}"
    else
      coins
    end
  end
end
