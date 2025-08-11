class ProductPrice < ApplicationRecord
  belongs_to :product

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true

  scope :active, -> { where(is_active: true) }
  scope :current, -> { where('start_date <= ? AND (end_date IS NULL OR end_date >= ?)', Time.current, Time.current) }

  def current?
    start_date <= Time.current && (end_date.nil? || end_date >= Time.current)
  end

  def expired?
    end_date && end_date < Time.current
  end
end