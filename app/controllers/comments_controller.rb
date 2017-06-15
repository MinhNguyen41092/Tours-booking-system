class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_commentable

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user
    if !@comment.save
      flash[:danger] = t "comments.create_failed"
    end
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit :body
  end

  def find_commentable
    @commentable = Comment.find_by(id: params[:comment_id]) if params[:comment_id]
    @commentable = Review.find_by(id: params[:review_id]) if params[:review_id]
  end
end
