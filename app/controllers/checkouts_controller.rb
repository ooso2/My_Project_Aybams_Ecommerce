class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty

  def show
    @cart_items = cart_products_with_quantities
    @order = current_user.orders.build
    
    # Pre-fill with user's saved address
    if current_user.address.present?
      @order.assign_attributes(
        shipping_first_name: current_user.first_name,
        shipping_last_name: current_user.last_name,
        shipping_address: current_user.address,
        shipping_city: current_user.city,
        shipping_province: current_user.province,
        shipping_postal_code: current_user.postal_code,
        shipping_country: current_user.country || 'Canada',
        shipping_phone: current_user.phone
      )
    end
  end

  def create
    @cart_items = cart_products_with_quantities
    @order = current_user.orders.build(order_params)
    
    # Generate order number
    @order.order_number = generate_order_number
    
    # Calculate totals
    subtotal = @cart_items.sum { |item| item[:subtotal] }
    tax = subtotal * 0.13 # 13% HST
    @order.subtotal = subtotal
    @order.tax_amount = tax
    @order.shipping_cost = 0 # Free shipping for now
    @order.total_amount = subtotal + tax

    # Create order items from cart
    @cart_items.each do |item|
      @order.order_items.build(
        product: item[:product],
        quantity: item[:quantity],
        price_at_purchase: item[:product].current_price,
        subtotal: item[:subtotal]
      )
    end

    if @order.save
      # Create payment record
      @order.create_payment(
        payment_method: 'credit_card',
        payment_status: 'completed',
        amount: @order.total_amount,
        transaction_id: SecureRandom.hex(16),
        payment_date: Time.current
      )

      # Reduce inventory
      @order.order_items.each do |item|
        product = item.product
        product.update!(stock_quantity: product.stock_quantity - item.quantity)
      end

      # Clear cart after successful order
      clear_cart
      
      redirect_to order_path(@order), notice: 'Order placed successfully!'
    else
      # Debug: show what went wrong
      Rails.logger.error "Order creation failed: #{@order.errors.full_messages}"
      flash.now[:alert] = "There was an error with your order: #{@order.errors.full_messages.join(', ')}"
      render :show
    end
  end

  private

  def ensure_cart_not_empty
    if current_cart.blank?
      redirect_to cart_path, alert: 'Your cart is empty.'
    end
  end

  def generate_order_number
    "AYB#{Date.current.strftime('%Y%m%d')}#{format('%04d', Order.count + 1)}"
  end

  def order_params
    params.require(:order).permit(
      :shipping_first_name, :shipping_last_name, :shipping_address,
      :shipping_city, :shipping_province, :shipping_postal_code,
      :shipping_country, :shipping_phone, :notes
    )
  end

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
