class LineItemsController < ApplicationController
  include CartOrder
  before_action :set_cart, :load_tour, only: :create
  before_action :load_line_item, only: [:update, :destroy]

  def create
    @line_item = LineItem.new tour_id: @tour.id, price: @tour.price
    find_line_itemable @line_item, @cart
    if @line_item.save
      flash[:success] = t "line_items.create_success"
      redirect_to @line_item.line_itemable
    else
      flash[:danger] = t "line_items.create_failed"
      redirect_to :back
    end
  end

  def update
    if @line_item.update line_items_params
      itemPrice @line_item
      flash[:success] = t "line_items.updated"
      redirect_to :back
    else
      flash[:danger] = t "line_items.update_failed"
    end
  end

  def destroy
    if @line_item.destroy
      flash[:success] = t "line_items.deleted"
    else
      flash[:danger] = t "line_items.delete_failed"
    end
    redirect_to :back
  end

  private

  def load_tour
    @tour = Tour.find_by id: params[:tour_id]
    return if @tour
    flash[:danger] = t "tours.not_found"
    redirect_to :back
  end

  def find_line_itemable item, cart
    item.line_itemable_id = cart.id
    item.line_itemable_type = cart.class.name
  end

  def load_line_item
    @line_item = LineItem.find_by id: params[:id]
    return if @line_item
    flash[:danger] = t "line_items.not_item"
    redirect_to products_path
  end

  def line_items_params
    params.require(:line_item).permit :travelers, :price, :tour_id
  end
end
