require 'rails_helper'

RSpec.feature "Campaigns", type: :feature do
  it "displays 'All Campaigns' on the home page" do
    visit campaigns_path
    expect(page).to have_text "All Campaigns"
  end

  it "displays a `Recent Campaigns` text in an h2 tag" do
    visit campaigns_path
    expect(page).to have_selector "h2", text: "Recent Campaigns"
  end

  it "displays a campaign's title" do
    campaign = FactoryGirl.create :campaign
    visit campaigns_path
    expect(page).to have_text /#{campaign.title}/i
  end

end
