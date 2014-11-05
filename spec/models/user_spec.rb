# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

describe User do

  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it '#email returns a string' do
    expect(@user.email).to match 'user@example.com'
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: {email: user.email}) }

    context 'user already has authorization' do
      let(:user) { create(:facebook_user) }

      it 'returns the user' do
        expect(User.find_for_oauth(auth)).to eq(user)
      end
    end

    context 'user without authorization' do
      let!(:user) { create(:user) }

      context 'existing user' do
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(Authorization, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          User.find_for_oauth(auth)
          expect(Authorization.last.provider).to eq(auth.provider)
          expect(Authorization.last.uid).to eq(auth.uid)
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: 'new@user.com'}) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          expect(User.find_for_oauth(auth).email).to eq(auth.info.email)
        end

        it 'creates authorization for user' do
          expect(User.find_for_oauth(auth).authorizations.size).to eq(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.take
          expect(authorization.provider).to eq(auth.provider)
          expect(authorization.uid).to eq(auth.uid)
        end
      end

      context 'auth without email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }
        let(:not_existing_auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '99999') }
        let(:user) { create(:facebook_user) }
        it 'loads existing user' do
          expect(User.find_for_oauth(auth)).to eq(user)
        end
        it 'returns nil' do
          expect(User.find_for_oauth(not_existing_auth)).to be_nil
        end
      end
    end
  end
end
