require 'spec_helper'

describe Video do
  # no need to test video.save because video.save is implemented by rails automatically. We should only test code we write ourselves. 
  # we are testing that we have declared belongs_to and validates_presence_of relationships in Video Model (not its implementation)
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end