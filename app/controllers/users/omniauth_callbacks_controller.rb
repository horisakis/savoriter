# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end
  def google
    common_callback
  end

  def twitter
    common_callback
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  private

  def common_callback
    auth_info = request.env['omniauth.auth']
    auth = Auth.find_by_omniauth(auth_info)

    ActiveRecord::Base.transaction do
      if auth.present?
        # @user = User.find(@auth.user_id)
        @user = auth.user
      else
        if user_signed_in?
          @user = current_user
        else
          @user = User.new(email: "#{auth_info.uid}.#{auth_info.provider}@example.com",
                           password: Devise.friendly_token[0, 20])
          @user.skip_confirmation!
          @user.save
        end

        auth = Auth.create_from_omniauth(@user.id, auth_info)
      end
    end

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: auth.provider) if is_navigational_format?
  end
end
