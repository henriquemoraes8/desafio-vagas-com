User.destroy_all
Job.destroy_all
Application.destroy_all
Path.destroy_all
Location.destroy_all

%w(A B C D E F).each do |l|
  Location.create(name: l)
end

paths = [
    {location1: 'A', location2: 'B', distance: 5},
    {location1: 'B', location2: 'C', distance: 7},
    {location1: 'B', location2: 'D', distance: 3},
    {location1: 'C', location2: 'E', distance: 4},
    {location1: 'D', location2: 'E', distance: 10},
    {location1: 'D', location2: 'F', distance: 8},
]

locations = Location.all;

paths.each do |p|
  Path.create(distance: p[:distance], location1_id: locations.find_by_name(p[:location1]).id, location2_id: locations.find_by_name(p[:location2]).id)
end

puts 'Sucesso!'