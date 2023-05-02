class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Sets session data following successful Calnet login
  def calnet
    Rails.logger.debug({
      message: 'Received omniauth calnet callback',
      omniauth_params: auth_params
    }.to_json)

    user = User.from_calnet(auth_params)
    print user.calnet_uid
    sign_in user

    # @note Devise clears session variables matching "devise.*" after sign in,
    # so we must add this supplemental data *after* calling sign_in.
    # set_roles_from_casauth(auth_params)

    redirect_to params[:url] || root_path
  rescue StandardError => e
    logger.error "Calnet | ERROR: #{e.inspect}"
    flash[:error] = t('omniauth.calnet.failure')
    redirect_to root_path
  end

  private

  def auth_params
    request.env['omniauth.auth']
  end
end
