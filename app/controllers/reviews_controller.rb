class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :verify_admin, only: :index
  before_action :load_review, only: [:update, :destroy]

  def index
    @reviews = Review.all.newest.page(params[:page])
      .per Settings.items_per_pages
  end

  def create
    @review = Review.new review_params
    @review.user = current_user
    if @review.save
      flash[:success] = t "reviews.created"
    else
      flash[:danger] = t "reviews.create_failed"
    end
    redirect_to :back
  end

  def update
    if @review.update_attribute :is_accepted, params[:is_accepted]
      flash[:success] = t "reviews.updated"
    else
      flash[:danger] = t "reviews.update_failed"
    end
    redirect_to :back
  end

  def destroy
    if @review.destroy
      flash[:success] = t "reviews.deleted"
    else
      flash[:danger] = t "reviews.delete_failed"
    end
    redirect_to :back
  end

  private

  def review_params
    params.require(:review).permit :title, :body, :tour_id
  end

  def load_review
    @review = Review.find_by id: params[:id]
    return if @review
    flash[:danger] = t "reviews.not_found"
    redirect_to :back
  end
end
