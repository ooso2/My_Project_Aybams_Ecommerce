class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_one :payment, dependent: :destroy

  # Validations
  validates :shipping_first_name, :shipping_last_name, :shipping_address, 
            :shipping_city, :shipping_province, :shipping_postal_code, presence: true
  validates :order_number, presence: true, uniqueness: true
  validates :subtotal, :tax_amount, :total_amount, presence: true, numericality: { greater_than: 0 }

  # Status enum
  enum status: { pending: 0, processing: 1, shipped: 2, delivered: 3, cancelled: 4 }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  before_validation :generate_order_number, on: :create
  before_save :calculate_totals

  def shipping_address_full
    [
      "#{shipping_first_name} #{shipping_last_name}",
      shipping_address,
      "#{shipping_city}, #{shipping_province} #{shipping_postal_code}",
      shipping_country
    ].compact.join("\n")
  end

  def total_items
    order_items.sum(:quantity)
  end

  private

  def generate_order_number
    self.order_number = "AYB#{Date.current.strftime('%Y%m%d')}#{format('%04d', Order.count + 1)}"
  end

  def calculate_totals
    if order_items.any?
      self.subtotal = order_items.sum { |item| item.quantity * item.price_at_purchase }
      self.tax_amount = subtotal * 0.13
      self.shipping_cost ||= 0
      self.total_amount = subtotal + tax_amount + shipping_cost
    end
  end
end
