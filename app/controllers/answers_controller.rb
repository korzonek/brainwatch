class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_filter :set_question, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      @answer = Answer.new
      render :create
    else
      respond_to do |format|
        format.js {render :new}
      end
    end
  end

  def accept
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @question.accept_answer(@answer) if @question.author?(current_user)
  end

  private
  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
