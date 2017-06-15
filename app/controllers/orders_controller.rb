class OrdersController < ApplicationController
  include CartOrder
  before_action :set_cart, only: [:new, :create]
  before_action :verify_admin, only: :index
  before_action :load_order, only: [:show, :update, :destroy, :payment]

  def index
    @orders = Order.newest.page(params[:page])
      .per Settings.items_per_pages
  end

  def new
    @order = Order.new
    @cart.line_items.each do |item|
      @order.line_items.build tour_id: item.tour_id, price: item.price,
        travelers: item.travelers
    end
  end

  def create
    @order = Order.new order_params
    @order.user = current_user
    if @order.save
      @cart.line_items.destroy_all
      send_mail @order
      checkout_paypal @order
    else
      render :new
    end
  end

  def show; end

  def success
    @order = Order.find_by id: params[:id]
    if @order.express_payer_id = params[:PayerID] # Paypal return payerid if success. Save it to db
      @order.status = 1
      @order.save
      send_mail @order
    else
      redirect_to error_order_path
    end
  end

  def error
    @order = Order.find_by id: params[:id]
    @errors = GATEWAY.details_for(@order.express_token) # To get details of payment
    @order.status = 2
    @order.save
    send_mail @order
  end

  def update
    if params[:status]
      @order.update status: params[:status]
      flash[:success] = t "orders.cancel"
    elsif @order.update order_params
      send_mail @order
      flash[:success] = t "orders.updated"
    else
      flash[:danger] = t "orders.update_failed"
    end
    redirect_to :back
  end

  def destroy
    if @order.destroy
      flash[:success] = t "orders.deleted"
    else
      flash[:danger] = t "orders.delete_failed"
    end
    redirect_to :back
  end

  def payment
    checkout_paypal @order
  end

  private

  def order_params
    params.require(:order).permit :email, :phone_number, :status, :total_cost,
      line_items_attributes: [:tour_id, :price, :travelers, :traveler_name,
      :start_date]
  end

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order
    flash[:danger] = t "orders.not_found"
    redirect_to root_path
  end

  def checkout_paypal order
    paypal_response = EXPRESS_GATEWAY.setup_purchase(
      (order.total_cost * 100).round, # paypal amount is in cents
      ip: request.remote_ip,
      return_url: success_order_url(order), # return here if payment success
      cancel_return_url: error_order_url(order) # return here if payment failed
    )
    order.express_token = paypal_response.token # save paypal token to db
    order.save
    redirect_to EXPRESS_GATEWAY.redirect_url_for(paypal_response.token) # redirect to paypal for payment
  end
end
