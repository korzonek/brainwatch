class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  respond_to :js

  def new
    @comment = Comment.new
  end

  def create
    @commentable = @answer || @question
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    respond_with(@comment, :layout => !request.xhr?)
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    @commentable = comment.commentable
    comment.destroy if comment
  end

  private

  def set_commentable
    @question = Question.find(params[:question_id]) if params[:question_id]
    @answer = @question.answers.find(params[:answer_id]) if params[:answer_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
