class NotificationsMailer < ApplicationMailer
  def signup
    mail to: 'fake@berkeley.edu', subject: 'notice', body: 'This is a notice from UCB@Geodata'
  end
end
