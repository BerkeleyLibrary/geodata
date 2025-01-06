class SessionsController < ApplicationController
  def destroy
    sign_out current_user if signed_in?
    redirect_to calnet_logout_url, allow_other_host: true
  end
end
