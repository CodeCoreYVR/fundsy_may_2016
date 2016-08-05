class StripeHandler::CreateCustomer
  include Virtus.model

  attribute :user,         User
  attribute :stripe_token, String

  attribute :stripe_customer, Stripe::Customer

  def call
    begin
      create_customer_with_api
    rescue => e
      # notify admin with details about exception `e`
      false
    end
  end

  private

  def create_customer_with_api
    @stripe_customer = Stripe::Customer.create(description: description, source: stripe_token)
    true
  end

  def description
    "Customer for user id: #{user.id} / #{user.full_name}"
  end

end
