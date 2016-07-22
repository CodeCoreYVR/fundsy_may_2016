class SendNewsLetterJob < ActiveJob::Base
  queue_as :default

  def perform(campaigns, user)
    puts "Sending newsletter to user #{user.full_name}"
  end
end
