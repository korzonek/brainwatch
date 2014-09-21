require 'rails_helper'

describe QuestionsController, :type => :controller do
  let(:question) { create(:question) }
  let(:user) {create(:user)}

  describe 'GET #index' do
    let(:questions) { create_list(:question, 12) }

    before { get :index }

    it('should populate questions') { expect(assigns(:questions)).to match_array questions.reverse.take(10) }
    it('should render index view') { expect(response).to render_template :index }
  end

  describe 'GET #show' do
    it 'should assign existing question as @question' do
      get :show, id: question
      expect(assigns(:question)).to eq(question)
    end
  end

  describe 'GET #new' do
    it 'should assign new question as @question' do
      sign_in user
      get :new
      expect(assigns(:question)).to be_a_new(Question)
    end

  end

  describe 'GET #edit' do
    let(:question) { create(:question) }

    it 'should assign existing question as @question' do
      sign_in user
      get :edit, id: question
      expect(assigns(:question)).to eq(question)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before {sign_in user}
      it 'should create a Question ' do
        expect {
          post :create, question: attributes_for(:question)
        }.to change(Question, :count).by(1)
      end

      it 'should redirect to show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'should set current user as question creator' do
        post :create, question: attributes_for(:question)
        expect(Question.last.user).to eq user
      end

    end

    context 'with invalid attributes' do
      it 'should not save invalid question' do
        post :create, question: attributes_for(:invalid_question)
        expect(assigns(:question)).to be_a_new Question
      end

      it "re-renders the 'new' template" do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template("new")
      end
    end

  end

  describe 'PATCH #update' do
    before {sign_in user}
    context "with valid attributes" do
      it 'should assign requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
        expect(response).to redirect_to question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: {title: 'changed title', body: 'changed body'}
        question.reload
        expect(question.title).to eq 'changed title'
        expect(question.body).to eq 'changed body'
      end
    end

    context 'with invalid attributes' do
      it 'should assign requested question to @question' do
        patch :update, id: question, question: {title: nil, body: nil}
        expect(assigns(:question)).to eq question
        expect(response).to render_template("edit")
      end
    end
  end

  describe 'DELETE #destroy' do
    before {sign_in user}
    it 'should delete the question' do
      question
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      expect(response).to redirect_to questions_path
    end
  end
end
