class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty
  before_action :set_order, except: [:create]

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
        shipping_country: current_user.country,
        shipping_phone: current_user.phone,
        billing_first_name: current_user.first_name,
        billing_last_name: current_user.last_name,
        billing_address: current_user.address,
        billing_city: current_user.city,
        billing_province: current_user.province,
        billing_postal_code: current_user.postal_code,
        billing_country: current_user.country,
        billing_phone: current_user.phone
      )
    end
  end

  def create
    @order = current_user.orders.build(order_params)
    @cart_items = cart_products_with_quantities

    # Create order items
    @cart_items.each do |item|
      @order.order_items.build(
        product: item[:product],
        quantity: item[:quantity],
        price_at_purchase: item[:product].sale_price
      )
    end

    if @order.save
      # Reduce stock quantities
      @order.order_items.each do |item|
        item.product.reduce_stock!(item.quantity)
      end

      # Create payment record
      @order.create_payment(
        payment_method: params[:payment_method] || 'credit_card',
        payment_status: 'completed', # In real app, this would be processed
        amount: @order.total_amount,
        transaction_id: SecureRandom.hex(16),
        payment_date: Time.current
      )

      # Process the order
      @order.process! if @order.may_process?

      # Clear cart
      clear_cart

      redirect_to order_path(@order), notice: 'Order placed successfully!'
    else
      render :show, alert: 'There was an error processing your order.'
    end
  end

  private

  def ensure_cart_not_empty
    if current_cart.blank?
      redirect_to cart_path, alert: 'Your cart is empty.'
    end
  end

  def set_order
    @order = current_user.orders.find(params[:id]) if params[:id]
  end

  def order_params
    params.require(:order).permit(
      :shipping_first_name, :shipping_last_name, :shipping_address,
      :shipping_city, :shipping_province, :shipping_postal_code,
      :shipping_country, :shipping_phone,
      :billing_first_name, :billing_last_name, :billing_address,
      :billing_city, :billing_province, :billing_postal_code,
      :billing_country, :billing_phone, :notes
    )
  end
end

# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.orders.includes(:order_items, :products).recent.page(params[:page]).per(10)
  end

  def show
    authorize @order
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: 'Order not found.'
  end
end