class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @q = Product.ransack(params[:q])
    @products = Product.includes(:category).page(params[:page]).per(20)
  end

  def show
  end

  def new
    @product = Product.new
    @categories = Category.where(active: true).order(:name)
  end

  def create
    @product = Product.new(product_params)
    @categories = Category.where(active: true).order(:name)

    if @product.save
      redirect_to admin_products_path, notice: 'Product created successfully.'
    else
      render :new
    end
  end

  def edit
    @categories = Category.where(active: true).order(:name)
  end

  def update
    @categories = Category.where(active: true).order(:name)

    if @product.update(product_params)
      redirect_to admin_products_path, notice: 'Product updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: 'Product deleted successfully.'
  end

  private

  def set_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :short_description, :current_price,
                                   :compare_at_price, :stock_quantity, :category_id, :sku,
                                   :weight, :dimensions, :is_active, :featured, :on_sale,
                                   :material, :origin_country, images: [])
  end
end