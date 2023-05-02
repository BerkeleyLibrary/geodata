class SessionsController < ApplicationController
  def new
    return_url = params[:url] || request.referer || root_path
    redirect_to user_calnet_omniauth_authorize_path(url: return_url)
  end

  def destroy
    sign_out current_user if signed_in?
    redirect_to calnet_logout_url, allow_other_host: true
  end
end
