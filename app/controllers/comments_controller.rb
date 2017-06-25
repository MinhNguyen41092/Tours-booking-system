class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_commentable
  before_action :load_comment, only: :destroy
  before_action :verify_admin, only: :destroy

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user
    if !@comment.save
      flash[:danger] = t "comments.create_failed"
    end
    redirect_to :back
  end

  def destroy
    if @comment.destroy
      flash[:success] = "Comment has been deleted"
    else
      flash[:danger] = "Could not delete comment"
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

  def load_comment
    @comment = Comment.find_by id: params[:id]
    return if @comment
    flash[:danger] = t "comment.not_found"
    redirect_to :back
  end
end
