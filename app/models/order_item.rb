class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_at_purchase, presence: true, numericality: { greater_than: 0 }

  before_validation :set_price_at_purchase
  before_save :calculate_subtotal

  def total_price
    quantity * price_at_purchase
  end

  private

  def set_price_at_purchase
    self.price_at_purchase = product.sale_price if product
  end

  def calculate_subtotal
    self.subtotal = total_price
  end
end