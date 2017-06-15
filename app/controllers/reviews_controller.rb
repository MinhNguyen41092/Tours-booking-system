class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :verify_admin, only: :index

  def index
    @reviews = Review.all
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

  private

  def review_params
    params.require(:review).permit :title, :body, :tour_id
  end
end
