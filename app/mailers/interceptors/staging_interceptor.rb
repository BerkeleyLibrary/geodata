# Re-routes emails from their intended recipients to a mailing list
#
# The original To/CC/BCC are stored in X-Original-### headers, which you can
# inspect when doing QA on the staging site.
module Interceptors
  class StagingInterceptor
    def self.delivering_email(mail)
      # Use headers to indicate who we would have emailed. Note that we don't add
      # this to the body so as not to mess up HTML/Text content.
      mail.header['X-LAP-Service'] = 'geodata'
      mail.header['X-Original-To'] = mail.to
      mail.header['X-Original-CC'] = mail.cc
      mail.header['X-Original-BCC'] = mail.bcc

      # Forward solely to the test list
      mail.to = 'lib-testmail@lists.berkeley.edu'
      mail.cc = mail.bcc = ''
    end
  end
end
