class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_one :payment, dependent: :destroy

  # Validations (all attributes included)
  validates :shipping_first_name, :shipping_last_name, :shipping_address, 
            :shipping_city, :shipping_province, :shipping_postal_code,
            :shipping_country, :shipping_phone, presence: true
  validates :billing_first_name, :billing_last_name, :billing_address, 
            :billing_city, :billing_province, :billing_postal_code,
            :billing_country, :billing_phone, presence: true
  validates :order_number, presence: true, uniqueness: true
  validates :subtotal, :tax_amount, :total_amount, :shipping_cost, 
            presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :notes, presence: true, allow_blank: true
  validates :order_date, presence: true

  # Status enum
  enum status: { pending: 0, processing: 1, shipped: 2, delivered: 3, cancelled: 4 }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  before_validation :generate_order_number, on: :create
  before_save :calculate_totals

  # Set default order date
  after_initialize :set_default_order_date, if: :new_record?

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id created_at updated_at user_id order_number subtotal tax_amount 
      total_amount shipping_cost status notes order_date
      shipping_first_name shipping_last_name shipping_address 
      shipping_city shipping_province shipping_postal_code shipping_country shipping_phone
      billing_first_name billing_last_name billing_address 
      billing_city billing_province billing_postal_code billing_country billing_phone
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  def shipping_address_full
    [
      "#{shipping_first_name} #{shipping_last_name}",
      shipping_address,
      "#{shipping_city}, #{shipping_province} #{shipping_postal_code}",
      shipping_country,
      "Phone: #{shipping_phone}"
    ].compact.join("\n")
  end

  def billing_address_full
    [
      "#{billing_first_name} #{billing_last_name}",
      billing_address,
      "#{billing_city}, #{billing_province} #{billing_postal_code}",
      billing_country,
      "Phone: #{billing_phone}"
    ].compact.join("\n")
  end

  def total_items
    order_items.sum(:quantity)
  end

  private

  def generate_order_number
    return if order_number.present?
    date_code = Time.current.strftime('%Y%m%d')
    last_order = Order.where("order_number LIKE ?", "AYB#{date_code}%").order(:id).last
    sequence = last_order ? last_order.order_number[-4..-1].to_i + 1 : 1
    self.order_number = "AYB#{date_code}#{format('%04d', sequence)}"
  end

  def set_default_order_date
    self.order_date ||= Time.current
  end

  def calculate_totals
    if order_items.any?
      self.subtotal = order_items.sum { |item| item.quantity * item.price_at_purchase }
      self.tax_amount = subtotal * 0.13 # Adjust tax rate as needed
      self.shipping_cost ||= 0
      self.total_amount = subtotal + tax_amount + shipping_cost
    end
  end
end