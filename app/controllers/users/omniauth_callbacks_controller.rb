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

  def after_sign_in_path_for(_resource)
    auths_path
  end

  private

  def common_callback
    result = { type: :alert, value: :failure }
    auth_info = request.env['omniauth.auth']
    auth = Auth.find_by_omniauth(auth_info)

    ActiveRecord::Base.transaction do
      if auth.present?
        # @user = User.find(@auth.user_id)
        @user = auth.user
        result = { type: :notice, value: :success }
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
        result = { type: :notice, value: :success }
      end
    end
    set_flash_message(result[:type], result[:value], kind: auth.provider, reason: :DB登録エラー) if is_navigational_format?

    if result[:value] == :success
      sign_in_and_redirect @user, event: :authentication
    elsif signed_in?
      redirect_to auths_path
    else
      redirect_to unauthenticated_root_path
    end
  end
end
