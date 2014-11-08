class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy, :create]
  authorize_resource
  before_action :set_question, only: [:show]
  before_action :set_question_from_author, only: [:edit, :update, :destroy]

  respond_to :html, :js

  def index
    respond_with(@questions = Question.limit(10).order(created_at: :desc))
  end

  def new
    @question = Question.new
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def edit
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  def show
    @answer = Answer.new
    @comment = Comment.new
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def set_question_from_author
    @question = current_user.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :tags_str, attachments_attributes: [:file, :id, :_destroy])
  end
end
