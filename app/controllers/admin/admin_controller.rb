module Admin
  class Admin::AdminController < Admin::BaseController
    before_action :authenticate_user!
    before_action :ensure_admin
    layout "admin"

    def dashboard
      @total_products     = Product.count
      @total_orders       = Order.count
      @total_customers    = User.customer.count
      @recent_orders      = Order.order(created_at: :desc).limit(10)
      @recent_users       = User.order(created_at: :desc).limit(10)
      @recent_products    = Product.order(created_at: :desc).limit(10)
      @low_stock_products = Product.where("stock_quantity <= ?", 5).order(:stock_quantity).limit(10)
      @total_revenue      = 0

      # Remove this line to let Rails find the view automatically
      # render template: "admin/dashboard"
    end

    private

    def ensure_admin
      redirect_to root_path, alert: "Access denied." unless current_user&.admin?
    end
  end
end