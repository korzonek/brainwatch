class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create, :new]
  before_action :set_comment, only: [:edit, :update, :destroy]
  respond_to :js

  def new
    @comment = Comment.new
  end

  def edit
  end

  def update
    @comment.update(comment_params)
  end

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)), :layout => !request.xhr?)
  end

  def destroy
    @commentable = @comment.commentable
    respond_with(@comment.destroy)
  end

  private

  def set_commentable
    @question = Question.find(params[:question_id]) if params[:question_id]
    @answer = @question.answers.find(params[:answer_id]) if params[:answer_id]
    @commentable = @answer || @question
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
