class AnswersController < ApplicationController
  before_filter :set_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question, notice: 'Answer created'
    else
      render 'questions/show'
    end
  end

  private
  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
