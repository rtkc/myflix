module StripeWrapper
  class Charge
    attr_reader :error_message, :response

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})

      begin
        response = Stripe::Charge.create(
          :amount => options[:amount],
          :currency => "usd",
          :source => options[:source],
          :description => options[:description]
        )
        new(response: response)
      rescue Stripe::CardError => stripe_error_response
        new(error_message: stripe_error_response)
      end
    end

    def successful?
      response.present?
    end
  end
end