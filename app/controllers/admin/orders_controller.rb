class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :edit, :update]

  def index
    @q = Order.ransack(params[:q])
    @orders = @q.result(distinct: true).recent.page(params[:page]).per(20)
  end

  def show
  end

  def edit
  end

  def update
    if @order.update(order_params)
      case params[:order][:status]
      when 'processing'
        @order.process! if @order.may_process?
      when 'shipped'
        @order.ship! if @order.may_ship?
      when 'delivered'
        @order.deliver! if @order.may_deliver?
      when 'cancelled'
        @order.cancel! if @order.may_cancel?
      end

      redirect_to admin_order_path(@order), notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :notes)
  end
end