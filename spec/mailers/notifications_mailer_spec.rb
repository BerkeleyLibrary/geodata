require 'rails_helper'

RSpec.describe NotificationsMailer, type: :mailer do
  describe 'Email notification' do
    let(:mail) { NotificationsMailer.signup.deliver_now }

    it 'can render the headers' do
      expect(mail.subject).to eq('notice')
      expect(mail.to).to eq(['fake@berkeley.edu'])
      expect(mail.from).to eq(['lib-geodata@berkeley.edu'])

    end

    it 'can render the body' do
      expect(mail.body.encoded).to match('This is a notice from UCB@Geodata')
    end
  end
end
