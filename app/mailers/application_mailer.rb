# Base class for mailers
class ApplicationMailer < ActionMailer::Base
  default from: 'coverImages@viginia.edu'
  layout 'mailer'
end
