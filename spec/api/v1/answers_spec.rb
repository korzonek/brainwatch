describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  describe 'GET questions answers' do
    context 'authorized' do
      let(:attachment) { create(:attachment) }
      let!(:question) { create(:question, answers: create_list(:answer, 3)) }
      let!(:answer) { create(:answer, question: question, comments: create_list(:comment, 1), attachments: [attachment]) }
      let(:comment) { answer.comments.first }


      before(:each) do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token
      end

      it 'returns response' do
        expect(response).to be_success
      end

      it 'returns 3 answers' do
        expect(response.body).to have_json_size(4).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/3/#{attr}")
        end
      end

    end
  end

  describe 'GET single answer ' do
    context 'authorized' do
      let(:attachment) { create(:attachment) }
      let!(:answer) { create(:answer, comments: create_list(:comment, 1), attachments: [attachment]) }
      let(:comment) { answer.comments.first }

      before(:each) do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token
      end

      it 'returns response' do
        expect(response).to be_success
      end

      %w(id body user_id created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(id body user_id).each do |attr|
        it "returns #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
        end
      end

      context 'attachments' do
        it "returns url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end
  end
end