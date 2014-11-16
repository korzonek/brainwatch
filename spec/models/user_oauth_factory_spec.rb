describe UserOauthFactory do

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: {email: user.email}) }

    context 'user already has authorization' do
      let(:user) { create(:facebook_user) }

      it 'returns the user' do
        expect(UserOauthFactory.find_for_oauth(auth)).to eq(user)
      end
    end

    context 'user without authorization' do
      let!(:user) { create(:user) }

      context 'existing user' do
        it 'does not create new user' do
          expect { UserOauthFactory.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { UserOauthFactory.find_for_oauth(auth) }.to change(Authorization, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          UserOauthFactory.find_for_oauth(auth)
          expect(Authorization.last.provider).to eq(auth.provider)
          expect(Authorization.last.uid).to eq(auth.uid)
        end

        it 'returns the user' do
          expect(UserOauthFactory.find_for_oauth(auth)).to be_a(User)
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: 'new@user.com'}) }

        it 'creates new user' do
          expect { UserOauthFactory.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(UserOauthFactory.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          expect(UserOauthFactory.find_for_oauth(auth).email).to eq(auth.info.email)
        end

        it 'creates authorization for user' do
          expect(UserOauthFactory.find_for_oauth(auth).authorizations.size).to eq(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = UserOauthFactory.find_for_oauth(auth).authorizations.take
          expect(authorization.provider).to eq(auth.provider)
          expect(authorization.uid).to eq(auth.uid)
        end
      end

      context 'auth without email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }
        let(:not_existing_auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '99999') }
        let(:user) { create(:facebook_user) }
        it 'loads existing user' do
          expect(UserOauthFactory.find_for_oauth(auth)).to eq(user)
        end
        it 'returns nil' do
          expect(UserOauthFactory.find_for_oauth(not_existing_auth)).to be_nil
        end
      end

      context 'create with email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '12345') }
        let(:email) { 'someuser@twitter.com' }

        it 'returns user' do
          expect(UserOauthFactory.create_for_oauth_and_email(auth, email)).to be_a User
          #todo создание пользования
        end
      end
    end
  end
end
