module CartOrder

  def itemPrice item
    price = item.tour.price * item.travelers
    item.update_attributes price: price
  end

  def cart_cost items
    total_cost = 0
    items.each do |item|
      total_cost += item.tour.price * item.travelers
    end
    total_cost
  end

  private

  def set_cart
    if user_signed_in?
      if current_user.cart.present?
        @cart = Cart.find_by id: current_user.cart.id
      else
        @cart = Cart.create user_id: current_user.id
      end
    else
      flash[:danger] = t "users.pls_log_in"
      redirect_to root_path
    end
  end
end