describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  describe 'GET questions' do
    it_behaves_like 'API Authenticable', :get, '/api/v1/questions'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before(:each) do
        get '/api/v1/questions', format: :json, access_token: access_token.token
      end

      it 'returns list questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      it 'returns short title' do
        expect(response.body).to be_json_eql(question.title.truncate(7).to_json).at_path('questions/0/short_title')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "returns #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET question' do
    let(:attachment) { create(:attachment) }
    let(:comment) { question.comments.first }
    let!(:question) { create(:question, comments: create_list(:comment, 1), attachments: [attachment]) }

    context 'authorized' do
      # it_behaves_like 'API Authenticable', :get, "/api/v1/questions/#{question.id}"

      before(:each) do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token
      end

      it 'returns response' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "returns #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'comment' do
        %w(id body user_id).each do |attr|
          it "returns #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it "returns url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end
  end

  describe 'POST question' do
    context 'authorized' do
      let(:question_attributes) { attributes_for(:question) }

      it_behaves_like 'API Authenticable', :post, '/api/v1/questions', {question: FactoryGirl.attributes_for(:question)}

      before(:each) do
        post "/api/v1/questions", question: question_attributes, format: :json, access_token: access_token.token
      end

      it 'returns response' do
        expect(response).to be_success
      end

      %w(title body).each do |attr|
        it "returns #{attr}" do
          expect(response.body).to be_json_eql(question_attributes[attr.to_sym].to_json).at_path("#{attr}")
        end
      end
    end
  end
end