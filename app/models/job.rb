class Job < ApplicationRecord

  belongs_to :location
  has_many :applications
  has_many :candidates, :through => :applications, source: :user

  validates :level, numericality: { only_integer: true, greater_than: 0, less_than: 6 }

  validates_presence_of :title, :company, allow_blank: false

  alias_attribute :empresa, :company
  alias_attribute :titulo, :title
  alias_attribute :descricao, :description
  alias_attribute :nivel, :level
  alias_attribute :localizacao, :location

end
