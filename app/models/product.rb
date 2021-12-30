class Product < ApplicationRecord
  belongs_to :user

  validate :cost_mul_of_5

  def cost_mul_of_5
    self.errors.add(:cost, 'Cost price should be multipal of 5') if self.cost%5 != 0  
  end
end
