module Admin
  class CategoriesController < Admin::BaseController
    before_action :set_category, only: [:show, :edit, :update, :destroy]

    # List all categories
    def index
      # Eager load parent, children, and products to avoid N+1 queries
      @categories = Category.includes(:parent, :children, :products).order(:name)
    end

    # Show a single category
    def show
    end

    # New category form
    def new
      @category = Category.new
      @categories = Category.all.order(:name) # For parent dropdown
    end

    # Create category
    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "Category created successfully."
      else
        @categories = Category.all.order(:name) # Reload dropdown if validation fails
        render :new
      end
    end

    # Edit category form
    def edit
      @categories = Category.where.not(id: @category.id).order(:name) # Exclude self
    end

    # Update category
    def update
      if @category.update(category_params)
        redirect_to admin_category_path(@category), notice: 'Category was successfully updated.'
      else
        @categories = Category.where.not(id: @category.id).order(:name)
        render :edit
      end
    end

    # Delete category
    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: 'Category was successfully deleted.'
    end

    private

    # Find category by ID or slug
    def set_category
      @category = Category.find_by(id: params[:id]) || Category.find_by(slug: params[:id])
      raise ActiveRecord::RecordNotFound unless @category
    end

    # Strong parameters
    def category_params
      params.require(:category).permit(:name, :description, :parent_id, :is_active, :sort_order)
    end
  end
end
