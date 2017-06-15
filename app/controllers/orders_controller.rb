class OrdersController < ApplicationController
  include CartOrder
  before_action :set_cart, only: [:new, :create]

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
      checkout_paypal @order
    else
      render :new
    end
  end

  def show
    @order = Order.find_by id: params[:id]
    @order.express_payer_id = params[:PayerID] # Paypal return payerid if success. Save it to db
    @order.save
    # Your success code - here & view
  end

  def error
    @order = Order.find_by id: params[:id]
    @errors = GATEWAY.details_for(@order.express_token) # To get details of payment
    # @s.params['message'] gives you error
  end

  private

  def order_params
    params.require(:order).permit :email, :phone_number, :status, :total_cost,
      line_items_attributes: [:tour_id, :price, :travelers, :traveler_name,
      :start_date]
  end

  def checkout_paypal order
    paypal_response = EXPRESS_GATEWAY.setup_purchase(
      (order.total_cost * 100).round, # paypal amount is in cents
      ip: request.remote_ip,
      return_url: order_url(order), # return here if payment success
      cancel_return_url: error_order_url(order) # return here if payment failed
    )
    order.express_token = paypal_response.token # save paypal token to db
    order.save
    redirect_to EXPRESS_GATEWAY.redirect_url_for(paypal_response.token) # redirect to paypal for payment
  end
end
