class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many :product_prices, dependent: :destroy
  has_many_attached :images

  validates :name, presence: true
  validates :sku, presence: true, uniqueness: true
  validates :current_price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :slug, uniqueness: true

  scope :active, -> { where(is_active: true) }
  scope :featured, -> { where(featured: true) }
  scope :on_sale, -> { where(on_sale: true) }
  scope :in_stock, -> { where('stock_quantity > 0') }
  scope :by_category, ->(category) { where(category: category) }
  scope :recently_updated, ->(days = 7) { where('updated_at > ?', days.days.ago) }
  scope :new_products, ->(days = 30) { where('created_at > ?', days.days.ago) }

  def in_stock?
    stock_quantity > 0
  end

  def on_sale?
    on_sale && sale_active?
  end

  def sale_active?
    return false unless sale_start_date && sale_end_date
    Time.current.between?(sale_start_date, sale_end_date)
  end

  def sale_price
    on_sale? && compare_at_price ? [current_price, compare_at_price].min : current_price
  end

  def discount_percentage
    return 0 unless on_sale? && compare_at_price && compare_at_price > current_price
    ((compare_at_price - current_price) / compare_at_price * 100).round
  end

  def main_image
    images.attached? ? images.first : nil
  end

  def price_history
    product_prices.order(start_date: :desc)
  end

  def reduce_stock!(quantity)
    update!(stock_quantity: stock_quantity - quantity)
  end

  def increase_stock!(quantity)
    update!(stock_quantity: stock_quantity + quantity)
  end

  def self.search(term)
    return all if term.blank?

    where("name ILIKE ? OR description ILIKE ? OR sku ILIKE ?",
          "%#{term}%", "%#{term}%", "%#{term}%")
  end

  def self.filter_by_status(status)
    case status
    when 'on_sale'
      on_sale
    when 'new'
      new_products
    when 'recently_updated'
      recently_updated
    when 'featured'
      featured
    else
      all
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      name description short_description sku slug
      material origin_country dimensions
      is_active featured on_sale
      current_price compare_at_price stock_quantity weight
      sale_start_date sale_end_date
      category_id created_at updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category]
    %w[product] # add others if you need to search/sort through them
  end

  private

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end