class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @pledge = Pledge.find params[:pledge_id]
  end

  def createx
    stripe_customer = Stripe::Customer.create(
      description: "Customer for user id: #{current_user.id} / #{current_user.full_name}",
      source: params[:stripe_token]
    )

    current_user.update(stripe_customer_id: stripe_customer.id)

    pledge = Pledge.find params[:pledge_id]

    stripe_charge = Stripe::Charge.create(
                      amount: (pledge.amount * 100).to_i,
                      currency: "cad",
                      customer: current_user.stripe_customer_id,
                      description: "Charge for pledge #{pledge.id} / #{pledge.campaign.title}"
                    )

    pledge.update(stripe_txn_id: stripe_charge.id)

    redirect_to pledge.campaign, notice: "Thanks for making the payment"
  end
end
