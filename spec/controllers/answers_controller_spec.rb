require 'rails_helper'

describe AnswersController, :type => :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { sign_in user }
      it 'should create a Answer ' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer)
        }.to change(Answer, :count).by(1)
      end

      it 'should redirect to show' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end

      it 'should set current user as answer creator' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(Answer.last.user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'should not save invalid answer' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(assigns(:answer)).to be_a_new Answer
      end

      it "re-renders the 'new' template" do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template("new")
      end
    end
  end

end