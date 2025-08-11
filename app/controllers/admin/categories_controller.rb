class Admin::CategoriesController < AdminController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.includes(:parent, :children).ordered
  end

  def show
  end

  def new
    @category = Category.new
    @parent_categories = Category.root_categories.active.ordered
  end

  def create
    @category = Category.new(category_params)
    @parent_categories = Category.root_categories.active.ordered

    if @category.save
      redirect_to admin_category_path(@category), notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def edit
    @parent_categories = Category.root_categories.active.ordered
  end

  def update
    @parent_categories = Category.root_categories.active.ordered

    if @category.update(category_params)
      redirect_to admin_category_path(@category), notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @category.products.any? || @category.children.any?
      redirect_to admin_categories_path, alert: 'Cannot delete category with products or subcategories.'
    else
      @category.destroy
      redirect_to admin_categories_path, notice: 'Category was successfully deleted.'
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :parent_id, :active, :sort_order)
  end
end