class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  def new
    @comment = Comment.new
  end

  def create
    #should validate comment created on owners object
    @commentable = @answer || @question
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      @answer = Answer.new
      render :create
    else
      respond_to do |format|
        format.js { render :new }
      end
    end
  end

  private

  def set_commentable
    @question = Question.find(params[:question_id])
    @answer = @question.find(params[:answer_id]) if params[:answer_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
