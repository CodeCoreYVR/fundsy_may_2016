class SendCampaignFinishReminderJob < ActiveJob::Base
  queue_as :default

  def perform(campaign)
    if campaign.pledged_amount < campaign.goal
      Rails.logger.info ">>>>>> SEND EMAIL TO USER"
    else
      Rails.logger.info ">>>>>> NO NEED TO SEND EMAIL TO USER"
    end
  end
end
