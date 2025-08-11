class Admin::PagesController < AdminController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = Page.ordered
  end

  def show
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to admin_page_path(@page), notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to admin_page_path(@page), notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to admin_pages_path, notice: 'Page was successfully deleted.'
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :content, :meta_description, :published, :sort_order)
  end
end