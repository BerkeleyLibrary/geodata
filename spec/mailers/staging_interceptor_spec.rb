require 'rails_helper'

RSpec.describe Interceptors::StagingInterceptor, type: :mailer do
  around do |test|
    ActionMailer::Base.register_interceptor(Interceptors::StagingInterceptor)
    test.run
    ActionMailer::Base.unregister_interceptor(Interceptors::StagingInterceptor)
  end

  it 'rewrites outbound mail to the test list' do
    mail = NotificationsMailer.signup
    mail.cc %w[a@berkeley.edu b@berkeley.edu]
    mail.bcc %w[c@berkeley.edu d@berkeley.edu]
    mail.deliver_now

    expect(mail.to).to eq %w[lib-testmail@lists.berkeley.edu]
    expect(mail.cc).to be_empty
    expect(mail.bcc).to be_empty
    expect(mail.header[:x_lap_service].value).to eq 'geodata'
    expect(mail.header[:x_original_to].value).to eq 'fake@berkeley.edu'
    expect(mail.header[:x_original_cc].value).to eq 'a@berkeley.edu, b@berkeley.edu'
    expect(mail.header[:x_original_bcc].value).to eq 'c@berkeley.edu, d@berkeley.edu'
  end
end
