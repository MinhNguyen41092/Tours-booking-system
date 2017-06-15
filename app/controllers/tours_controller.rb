class ToursController < ApplicationController
  before_action :verify_admin, except: [:index, :show]
  before_action :load_tour, except: [:index, :new, :create]

  def index
    @tours = Tour.all.page(params[:page])
      .per Settings.items_per_pages
  end

  def new
    @tour = Tour.new
  end

  def create
    @tour = Tour.new tour_params
    if @tour.save
      flash[:success] = t "tours.created"
      redirect_to tour_path(@tour)
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @tour.update tour_params
      flash[:success] = t "tours.updated"
      redirect_to tour_path(@tour)
    else
      render :edit
    end
  end

  def destroy
    if @tour.destroy
      flash[:success] = t "tours.deleted"
      redirect_to tours_path
    else
      flash[:danger] = t "tours.delete_failed"
      redirect_to :back
    end
  end

  private

  def load_tour
    @tour = Tour.find_by id: params[:id]
    return if @tour
    flash[:danger] = t "tours.not_found"
    redirect_to :back
  end

  def tour_params
    params.require(:tour).permit :name, :description, :price, :image_url,
      :duration, :location, :remove_image_url, :image_url_cache
  end
end
