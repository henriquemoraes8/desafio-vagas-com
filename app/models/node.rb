class Node
  include Comparable
  attr_reader :distance, :location_id

  def <=>(other)
    return nil if other.nil?
    return nil unless other.location_id.is_a? Integer
    if @distance > other.distance
      return -1
    elsif @distance > other.distance
      return 1
    else
      return 0
    end
  end

  def initialize(distance, location_id)
    @distance = distance
    @location_id = location_id
  end

end