class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def index
    @categories = Category.where(active: true).order(:name)
  end

  def show
    @products = @category.products.where(is_active: true).order(:name)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to categories_path, alert: 'Category not found.'
  end
end
