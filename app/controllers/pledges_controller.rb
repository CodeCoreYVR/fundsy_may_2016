class PledgesController < ApplicationController
  before_action :authenticate_user!

  def create
    @campaign        = Campaign.find params[:campaign_id]
    pledge_params    = params.require(:pledge).permit(:amount)
    @pledge          = Pledge.new pledge_params
    @pledge.campaign = @campaign
    @pledge.user     = current_user
    if @pledge.save
      redirect_to new_pledge_payment_path(@pledge), notice: "Thanks for pledging, please make a payment"
    else
      render "/campaigns/show"
    end
  end

end
