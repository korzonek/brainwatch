class Api::V1::AnswersController < Api::V1::ApiController

  def index
    respond_with Question.find(params[:question_id]).answers
  end

  def show
    respond_with Answer.find(params[:id]), serializer: SingleAnswerSerializer, root: false
  end

  def create
    question = Question.find(params[:question_id])
    respond_with current_resource_owner.answers.create(answers_params.merge(question: question)),
                 serializer: SingleAnswerSerializer, root: false
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end