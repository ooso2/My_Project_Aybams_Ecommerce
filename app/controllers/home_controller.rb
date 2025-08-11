class HomeController < ApplicationController
  def index
    @featured_products = Product.active.featured.limit(8)
    @categories = Category.where(active: true).limit(6)
    @recent_products = Product.active.order(created_at: :desc).limit(4)
  end
end
