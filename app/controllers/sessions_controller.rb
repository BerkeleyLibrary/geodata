class SessionsController < ApplicationController
  def new
    return_url = params[:url] || request.referrer || root_path
    redirect_to user_calnet_omniauth_authorize_path(url: return_url)
  end

  def destroy
    if signed_in?
      sign_out current_user
    end
    redirect_to calnet_logout_url, allow_other_host: true
  end
end
