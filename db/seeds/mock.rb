User.destroy_all
Job.destroy_all
Application.destroy_all

locations = Location.all

seeded_random = Random.new 100

20.times do |i|
  User.create(name: "Pessoa #{i}", job_description: "Dev #{i}", level: seeded_random.rand(1..5), location: locations[seeded_random.rand(0..(locations.size - 1))])
end

20.times do |i|
  Job.create(company: "Empresa #{i}", title: "Titulo #{i}", description: "Desc #{i}", level: seeded_random.rand(0..5), location: locations[seeded_random.rand(0..(locations.size - 1))])
end

users = User.all
jobs = Job.all

50.times do
  Application.create(job_id: jobs[seeded_random.rand(0..(jobs.size - 1))].id, user_id: users[seeded_random.rand(0..(users.size - 1))].id)
end

puts 'Sucesso!'