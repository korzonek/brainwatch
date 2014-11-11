describe 'Profile API' do
  let(:access_token) { create(:access_token) }

  describe 'GET /me' do
    it_behaves_like 'API Authenticable', :get, '/api/v1/profiles/me'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before(:each) do
        get '/api/v1/profiles/me', format: :json, access_token: access_token.token
      end

      it 'returns user' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at).each do |attr|
        it "returns #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "returns #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /all' do
    it_behaves_like 'API Authenticable', :get, '/api/v1/profiles/all'

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 10) }
      before(:each) do
        get '/api/v1/profiles/all', format: :json, access_token: access_token.token
      end

      it 'returns user' do
        expect(response).to be_success
      end

      it 'return all users' do
        expect(response.body).to have_json_size(10).at_path('profiles')
      end
    end
  end
end