class StripeHandler::ChargeCustomer

  include Virtus.model

  attribute :stripe_customer_id, String
  attribute :amount,             Float
  attribute :description,        String

  attribute :stripe_charge,       Stripe::Charge

  def call
    begin
      charge_customer_with_api
    rescue Stripe::CardError => exp_object
      # handling Stripe::CardError specifically
      false
    rescue => exp_object
      false
    end
  end

  private

  def charge_customer_with_api
    @stripe_charge = Stripe::Charge.create(
                      amount:      amount_in_cents,
                      currency:    "cad",
                      customer:    stripe_customer_id,
                      description: description
                    )
    true
  end

  def amount_in_cents
    (amount * 100).to_i
  end

end
