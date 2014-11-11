class UserOauthFactory

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