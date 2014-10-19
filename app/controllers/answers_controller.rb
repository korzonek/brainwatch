class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      @answer = Answer.new
      render :create
    else
      respond_to do |format|
        format.js { render :new }
      end
    end
  end

  def edit
    @answer = current_user.answers.find(params[:id])
  end

  def update
    @answer = current_user.answers.find(params[:id])
    @answer.update(answer_params) if @answer
  end

  def accept
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @question.accept_answer(@answer) if @question.author?(current_user)
  end

  def destroy
    answer = current_user.answers.find(params[:id])
    @question = answer.question
    answer.destroy if answer
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
