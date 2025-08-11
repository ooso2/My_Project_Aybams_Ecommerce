class ApplicationController < ActionController::Base
  include Pundit::Authorization

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_cart
    @current_cart ||= session[:cart] || {}
  end

  def add_to_cart(product_id, quantity = 1)
    session[:cart] ||= {}
    session[:cart][product_id.to_s] = (session[:cart][product_id.to_s] || 0) + quantity.to_i
  end

  def remove_from_cart(product_id)
    session[:cart]&.delete(product_id.to_s)
  end

  def update_cart_quantity(product_id, quantity)
    if quantity.to_i > 0
      session[:cart] ||= {}
      session[:cart][product_id.to_s] = quantity.to_i
    else
      remove_from_cart(product_id)
    end
  end

  def clear_cart
    session[:cart] = {}
  end

  def cart_total_items
    current_cart.values.sum
  end

  def cart_products_with_quantities
    return [] if current_cart.blank?

    product_ids = current_cart.keys
    products = Product.where(id: product_ids, is_active: true).includes(:category, images_attachments: :blob)

    products.map do |product|
      {
        product: product,
        quantity: current_cart[product.id.to_s],
        subtotal: product.sale_price * current_cart[product.id.to_s]
      }
    end
  end

  helper_method :current_cart, :cart_total_items, :cart_products_with_quantities

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :address, :city, :province, :postal_code, :country])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :address, :city, :province, :postal_code, :country])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end