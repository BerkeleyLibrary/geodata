class User < ApplicationRecord

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: [:calnet]
  class << self
    # Finds or creates a user record given data from the omniauth request hash
    def from_calnet(auth)
      where(calnet_uid: auth.uid).first_or_initialize do |user|
        user.email = auth.extra['berkeleyEduOfficialEmail'] || fake_email if user.email.blank?
        user.save!
      end
    end

    private

    # Generates a random email address
    def fake_email
      "fake-#{SecureRandom.hex[0, 16]}@noemail.com"
    end
  end
  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end
end
