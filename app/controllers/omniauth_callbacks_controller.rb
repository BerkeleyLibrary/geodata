class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Sets session data following successful Calnet login
  def calnet
    check_auth_params
    calnet_sign_in
    redirect_to params[:url] || root_path
  rescue StandardError => e
    logger.error "Calnet | ERROR: #{e.inspect}"
    flash[:error] = t('omniauth.calnet.failure')
    redirect_to root_path
  end


  private

  def calnet_sign_in
    user = User.from_calnet(auth_params)
    Rails.logger.info(user.calnet_uid)
    sign_in user
  end

  def auth_params
    request.env['omniauth.auth']
  end

  def check_auth_params
    Rails.logger.debug({
      message: 'Received omniauth calnet callback',
      omniauth_params: auth_params
    }.to_json)
  end

end
