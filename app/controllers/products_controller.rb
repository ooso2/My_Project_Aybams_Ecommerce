class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  
  def index
    @products = Product.where(is_active: true).includes(:category)
    
    # Search functionality
    if params[:search].present?
      @products = @products.where("name ILIKE ? OR description ILIKE ? OR sku ILIKE ?", 
                                  "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    # Category filter
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
      @current_category = Category.find(params[:category_id])
    end
    
    # Status filters
    case params[:filter]
    when 'on_sale'
      @products = @products.where(on_sale: true)
    when 'new'
      @products = @products.where('created_at > ?', 30.days.ago)
    when 'recently_updated'
      @products = @products.where('updated_at > ?', 7.days.ago)
    when 'featured'
      @products = @products.where(featured: true)
    end
    
    # Pagination (if you have kaminari gem)
    @products = @products.page(params[:page]).per(12) if defined?(Kaminari)
    
    @categories = Category.where(active: true).order(:name)
  end

  def show
    @related_products = Product.where(category: @product.category, is_active: true)
                              .where.not(id: @product.id)
                              .limit(4)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: 'Product not found.'
  end
end
