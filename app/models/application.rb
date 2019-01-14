class Application < ApplicationRecord
  belongs_to :user
  belongs_to :job

  alias_attribute :vaga, :job
  alias_attribute :pessoa, :user

  before_create :calculate_score

  scope :for_job, -> (job_id) {
    where(job_id: job_id).order(score: :desc)
  }

  def calculate_score
    self.score = (calculate_n(job.level, user.level) + calculate_d(job.location_id, user.location_id))/2
  end

  private

  def calculate_n (level_job, level_user)
    100 - 25 * (level_job - level_user).abs
  end

  def calculate_d (location_job, location_user)
    distance = shortest_path(location_job, location_user)
    score = 0

    interval = 5
    if distance == 0
      score = 100
    else
      score = 100 - 25 * ((distance - 0.01)/interval).floor
    end

    score
  end

  def shortest_path (location_job, location_user)
    priority_queue = PriorityQueue.new
    priority_queue << Node.new(0, location_user)
    distances = {}
    seen = []
    Location.all.each do |l|
      distances[l.id] = location_user == l.id ? 0 : Float::INFINITY
    end

    while priority_queue.size > 0
      node = priority_queue.pop
      edges = Path.where("location1_id = :id OR location2_id = :id", id: node.location_id)

      edges.each do |e|

        next if seen.include?(e.location1_id) || seen.include?(e.location2_id)

        other_id = e.location1_id == node.location_id ? e.location2_id : e.location1_id
        if distances[other_id] > distances[node.location_id] + e.distance
          distances[other_id] = distances[node.location_id] + e.distance
          priority_queue << Node.new(distances[other_id], other_id)
        end
      end

      seen << node.location_id

      return distances[location_job] if node.location_id == location_job

    end
    distances[location_job]
  end

end
