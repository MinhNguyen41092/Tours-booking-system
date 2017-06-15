class CartsController < ApplicationController
  include CartOrder
  before_action :set_cart, only: :destroy
  before_action :load_cart, only: :show

  def show; end

  def destroy
    if @cart.destroy
      flash[:success] = t "carts.deleted"
      redirect_to tours_path
    else
      flash[:danger] = t "carts.delete_failed"
      redirect_to :back
    end
  end

  private

  def load_cart
    @cart = Cart.find_by id: params[:id]
    return if @cart && (@cart.user = current_user)
    flash[:danger] = t "carts.not_found"
    redirect_to root_path
  end
end
