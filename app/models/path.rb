class Path < ApplicationRecord
  belongs_to :location1, class_name: 'Location', :foreign_key => 'location1_id'
  belongs_to :location2, class_name: 'Location', :foreign_key => 'location2_id'
end
