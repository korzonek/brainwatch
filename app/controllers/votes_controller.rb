class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable

  def up
    vote(1)
    render :update_vote
  end

  def down
    vote(-1)
    render :update_vote
  end

  def reset
    vote(0)
    render :update_vote
  end

  private

  def vote(score)
    @vote.update(score: score)
  end

  def set_votable
    @question = Question.find(params[:question_id]) if params[:question_id]
    @answer = @question.answers.find(params[:answer_id]) if params[:answer_id]
    @votable = @answer || @question
    @vote = @votable.votes.find_or_create_by(user: current_user)
  end

end


