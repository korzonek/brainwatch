class Api::V1::QuestionsController < Api::V1::ApiController

  def index
    respond_with Question.all
  end

  def show
    respond_with Question.find(params[:id]), serializer: SingleQuestionSerializer, root: false
  end

  def create
    respond_with current_resource_owner.questions.create(question_params), serializer: SingleQuestionSerializer, root: false
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end