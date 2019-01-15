require 'rails_helper'

load "#{Rails.root}/db/seeds/paths.rb"

RSpec.describe Application, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:job) }

  it 'should calculate the correct score for different levels' do
    user = User.create(name: "Example", job_description: "Example", level: 1, location_id: Location.first.id)
    job = Job.create(title: "example", company: "Example", level: 5, location_id: Location.first.id)
    application = Application.create(job_id: job.id, user_id: user.id)
    expect(application.score).to eq 50
  end

  it 'should calculate the correct score for different locations' do
    user = User.create(name: "Example", job_description: "Example", level: 5, location_id: Location.find_by_name('B').id)
    job = Job.create(title: "example", company: "Example", level: 5, location_id: Location.find_by_name('E').id)
    application = Application.create(job_id: job.id, user_id: user.id)
    expect(application.score).to eq 75
  end

  it 'should calculate the correct score' do
    user = User.create(name: "Example", job_description: "Example", level: 1, location_id: Location.find_by_name('F').id)
    job = Job.create(title: "example", company: "Example", level: 3, location_id: Location.find_by_name('C').id)
    application = Application.create(job_id: job.id, user_id: user.id)
    expect(application.score).to eq 37
  end
end
