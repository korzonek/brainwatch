class Api::V1::QuestionsController < Api::V1::ApiController

  def index
    respond_with Question.all
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, serializer: SingleQuestionSerializer, root: false
  end
end