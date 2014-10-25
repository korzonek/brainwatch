class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:edit, :update, :destroy]
  respond_to :js

  def create
    @answer = current_user.answers.create(answer_params.merge(question: @question))
  end

  def edit
    respond_with(@answer)
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def accept
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @question.accept_answer(@answer) if @question.author?(current_user)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = current_user.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
