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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :comments
  has_many :answers
  has_many :questions
  has_many :authorizations

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid).take
    return authorization.user if authorization
    if auth.info.try(:email)
      password = Devise.friendly_token[0, 20]
      user = User.where(email: auth.info.email).take || User.create!(email: auth.info.email, password: password, password_confirmation: password)
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
      user
    end
  end

  def self.create_for_oauth_and_email(auth, email)
    password = Devise.friendly_token[0, 20]
    user = User.create(email: email, password: password, password_confirmation: password)
    if user.persisted?
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
    user
  end
end

