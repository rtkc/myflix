require 'spec_helper'

describe Invitation do
  it { is_expected.to belong_to(:inviter) }
  it { is_expected.to validate_presence_of(:inviter) }
  it { is_expected.to validate_presence_of(:recipient_name) }
  it { is_expected.to validate_presence_of(:recipient_email) }

  it 'generates a random token' do
    Invitation.create(
      recipient_name: 'Jim Tealeaf',
      recipient_email: 'jim@email.com',
      inviter: Fabricate(:user))
    expect(Invitation.first.token).to be_present
  end
end
