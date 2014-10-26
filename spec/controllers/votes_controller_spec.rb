require 'rails_helper'

RSpec.describe VotesController, :type => :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #up' do
    before { sign_in user }
    it 'should create a up vote' do
      expect do
        post :up, question_id: question, format: :js
      end.to change(Vote, :count).by(1)
      expect(question.total_votes).to eq(1)
    end

    it 'should create a down vote' do
      expect do
        post :down, question_id: question, format: :js
      end.to change(Vote, :count).by(1)
      expect(question.total_votes).to eq(-1)
    end

    it 'should create a neutral vote' do
      expect do
        post :reset, question_id: question, format: :js
      end.to change(Vote, :count).by(1)
      expect(question.total_votes).to eq(0)
    end
  end
end
