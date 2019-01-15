require 'rails_helper'

RSpec.describe User, type: :model do

  it { should belong_to(:location) }
  it { should have_many(:applications) }
  it { should have_many(:applied_jobs).through(:applications) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:job_description) }
  it { should validate_numericality_of(:level).is_greater_than(0).is_less_than(6).only_integer }

end
