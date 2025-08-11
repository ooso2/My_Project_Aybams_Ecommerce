class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :parent_id }
  validates :slug, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :root_categories, -> { where(parent_id: nil) }
  scope :ordered, -> { order(:sort_order, :name) }

  def root?
    parent_id.nil?
  end

  def has_children?
    children.any?
  end

  def ancestors
    path = []
    current = self
    while current.parent
      current = current.parent
      path << current
    end
    path.reverse
  end

  def descendants
    result = []
    children.each do |child|
      result << child
      result += child.descendants
    end
    result
  end

  def product_count
    products.where(is_active: true).count
  end

  def total_product_count
    count = product_count
    descendants.each { |desc| count += desc.product_count }
    count
  end
end