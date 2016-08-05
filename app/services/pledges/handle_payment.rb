class Pledges::HandlePayment
  include Virtus.model

  attribute :stripe_token, String
  attribute :pledge,       Pledge
  attribute :user,         User

  def call
    create_stripe_customer &&
      update_user_with_stripe_customer_id &&
      charge_customer_with_stripe &&
      update_pledge_with_stripe_txn_id
  end

  private

  def create_stripe_customer
    service = StripeHandler::CreateCustomer.new user:         user,
                                                stripe_token: stripe_token
    if service.call
      @stripe_customer = service.stripe_customer
    else
      false
    end
  end

  def update_user_with_stripe_customer_id
    user.update(stripe_customer_id: @stripe_customer.id)
  end

  def charge_customer_with_stripe
    service = StripeHandler::ChargeCustomer.new amount: pledge.amount,
                                                stripe_customer_id: user.stripe_customer_id,
                                                description: charge_description

    if service.call
      @stripe_charge = service.stripe_charge
    else
      false
    end
  end

  def update_pledge_with_stripe_txn_id
    pledge.update(stripe_txn_id: @stripe_charge.id)
  end

  def charge_description
    "Charge for pledge #{pledge.id} / #{pledge.campaign.title}"
  end

end
