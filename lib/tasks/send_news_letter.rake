namespace :send_news_letter do

  desc "Send newsletter to all users"
  task :send_all => :environment do
    campaigns = Campaign.last(3)
    User.all.each do |user|
      SendNewsLetterJob.perform_later(campaigns, user)
    end
  end
end
