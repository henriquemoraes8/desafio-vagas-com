require 'rails_helper'

RSpec.describe Location, type: :model do
  it { should have_many(:users) }
  it { should have_many(:jobs) }
  it { should validate_presence_of(:name) }
end
