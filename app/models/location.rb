class Location < ApplicationRecord
  has_many :paths1, :class_name => 'Path', :dependent => :destroy, foreign_key: :location1_id
  has_many :paths2, :class_name => 'Path', :dependent => :destroy, foreign_key: :location2_id
  has_many :users
  has_many :jobs

  alias_attribute :nome, :name

  def paths
    Path.where("location1_id = :id OR location2_id = :id", id: id).order(distance: :asc)
  end

end
