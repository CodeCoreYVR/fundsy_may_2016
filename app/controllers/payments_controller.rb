class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_pledge

  def new
  end

  def create
    service = Pledges::HandlePayment.new stripe_token: params[:stripe_token],
                                         user:         current_user,
                                         pledge:       @pledge
    if service.call
      redirect_to @pledge.campaign, notice: "Thanks for making the payment"
    else
      flash[:error] = "Problem charging your card, please contact us"
      render :new
    end
  end

  private

  def find_pledge
    @pledge = Pledge.find params[:pledge_id]
  end
end
