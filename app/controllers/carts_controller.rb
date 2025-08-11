class CartsController < ApplicationController
  def show
    @cart_items = cart_products_with_quantities
    @cart_total = @cart_items.sum { |item| item[:subtotal] }
  end

  def add
    product = Product.find(params[:product_id])
    quantity = params[:quantity]&.to_i || 1
    
    if product.is_active? && product.stock_quantity >= quantity
      add_to_cart(product.id, quantity)
      redirect_back(fallback_location: root_path, notice: "#{product.name} added to cart!")
    else
      redirect_back(fallback_location: root_path, alert: "Sorry, insufficient stock available.")
    end
  end

  def update
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
    
    if quantity > 0
      product = Product.find(product_id)
      if product.stock_quantity >= quantity
        update_cart_quantity(product_id, quantity)
        redirect_to cart_path, notice: "Cart updated!"
      else
        redirect_to cart_path, alert: "Sorry, only #{product.stock_quantity} items available."
      end
    else
      remove_from_cart(product_id)
      redirect_to cart_path, notice: "Item removed from cart."
    end
  end

  def remove
    remove_from_cart(params[:product_id])
    redirect_to cart_path, notice: "Item removed from cart."
  end

  def clear
    clear_cart
    redirect_to cart_path, notice: "Cart cleared!"
  end

  private

  def cart_products_with_quantities
    return [] if current_cart.blank?
    
    product_ids = current_cart.keys
    products = Product.where(id: product_ids, is_active: true)
    
    products.map do |product|
      quantity = current_cart[product.id.to_s].to_i
      {
        product: product,
        quantity: quantity,
        subtotal: product.current_price * quantity
      }
    end
  end
end
