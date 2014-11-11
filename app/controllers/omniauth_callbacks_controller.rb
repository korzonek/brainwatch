class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = UserOauthFactory.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end

  def twitter
    @user = UserOauthFactory.find_for_oauth(request.env['omniauth.auth'])
    if @user.present? && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      session['omniauth.auth'] = request.env['omniauth.auth']
      render :email
    end
  end

  def twitter_continue
    @user = UserOauthFactory.create_for_oauth_and_email(OmniAuth::AuthHash.new(session['omniauth.auth']), params[:email])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      render :email
    end
  end
end