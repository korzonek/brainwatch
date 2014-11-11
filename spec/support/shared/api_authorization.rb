shared_examples_for 'API Authenticable' do |method, url, params|
  let(:access_token) { create(:access_token) }

  context 'unauthorized' do
    it 'returns 401 status if no access token' do
      xhr method, url, format: :json
      expect(response).to have_http_status(401)
    end
    it 'returns 401 status if access token is incorrect' do
      xhr method, url, format: :json, access_token: '1234'
      expect(response).to have_http_status(401)
    end
  end

  context 'authorized' do

    before(:each) do
      params||={}
      xhr method, url, {format: :json, access_token: access_token.token}.merge(params)
    end

    it 'returns response' do
      expect(response).to be_success
    end

  end
end