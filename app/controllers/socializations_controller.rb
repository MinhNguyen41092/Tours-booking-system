class SocializationsController < ApplicationController
  before_action :load_review

  def like
    current_user.like!(@review)
    redirect_to :back
  end

  def unlike
    current_user.unlike!(@review)
    redirect_to :back
  end

private
  def load_review
    @review = Review.find_by id: params[:review_id]
    return if @review
    flash[:danger] = t "reviews.not_found"
    redirect_to :back
  end
end
