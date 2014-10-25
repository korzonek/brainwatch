require 'rails_helper'

describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 12) }

    before { get :index }

    it('should populate questions') { expect(assigns(:questions)).to match_array questions.reverse.take(10) }
    it('should render index view') { expect(response).to render_template :index }
  end

  describe 'GET #show' do
    before do
      sign_in user
      get :show, id: question
    end

    it('should assign existing question as @question') { expect(assigns(:question)).to eq(question) }
  end

  describe 'GET #new' do
    before do
      sign_in user
      get :new
    end

    it('should assign new question as @question') { expect(assigns(:question)).to be_a_new(Question) }
  end

  describe 'GET #edit' do
    it 'should assign existing question as @question' do
      sign_in user
      xhr :get, :edit, id: question
      expect(assigns(:question)).to eq(question)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { sign_in user }
      it 'should create a Question ' do
        expect do
          post :create, question: attributes_for(:question)
        end.to change(Question, :count).by(1)
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
      before { sign_in user }
      it 'should not save invalid question' do
        post :create, question: attributes_for(:invalid_question)
        expect(assigns(:question)).to be_a_new Question
      end

      it 're-renders the \'new\' template' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }
    context 'with valid attributes' do
      it 'should assign requested question to @question' do
        xhr :patch, :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
        expect(response).to be_ok
      end

      it 'changes question attributes' do
        xhr :patch, :update, id: question, question: {title: 'changed title', body: 'changed body'}
        question.reload
        expect(question.title).to eq 'changed title'
        expect(question.body).to eq 'changed body'
      end
    end

    context 'with invalid attributes' do
      it 'should assign requested question to @question' do
        xhr :patch, :update, id: question, question: {title: nil, body: nil}
        expect(assigns(:question)).to eq question
        expect(response).to render_template('questions/update')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }
    it 'should delete the question' do
      question
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      expect(response).to redirect_to questions_path
    end
  end
end
