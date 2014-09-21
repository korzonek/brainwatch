class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.limit(10).order(created_at: :desc)
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Question created'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def edit
  end

  def show
    @answer = @question.answers.new
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
