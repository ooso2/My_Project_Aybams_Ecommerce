# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

   def index
    # Using Ransack search if you have it, otherwise just Product.all
    if defined?(Product) && respond_to?(:ransack)
      @q = Product.ransack(params[:q])
      @products = @q.result(distinct: true).includes(:category).page(params[:page]).per(20)
    else
      @products = Product.all
    end

    # Fallback to empty relation if something goes wrong (very defensive)
    @products ||= Product.none
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: "Product created successfully."
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: "Product updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Product deleted successfully."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :sku, :price, :category_id, :description, :main_image)
  end
end
