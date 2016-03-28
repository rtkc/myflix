require 'spec_helper' 

describe StripeWrapper do 
  describe StripeWrapper::Charge do 
    let(:token) do 
      Stripe::Token.create(
          :card => {
            :number => card_number,
            :exp_month => 3,
            :exp_year => 2017,
            :cvc => "314"
          },
        ).id 
    end

    describe ".create", :vcr  do 

      context "valid card" do 
        let(:card_number) { "4242424242424242" }

        it "makes a successful charge" do 
          response = StripeWrapper::Charge.create(
            amount: 999,
            card: token,
            description: "A valid charge."
            )
          response.should be_successful
        end
      end

      context "invalid card" do 
        let(:card_number) { "4000000000000002" }
        let(:response) { StripeWrapper::Charge.create(amount: 300, card: token)}

        it "does not charge card successfully" do 
          response.should_not be_successful
        end

        it "contains error message" do 
          response.error_message.should be_present
        end
      end
    end
  end
end