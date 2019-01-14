class Job < ApplicationRecord

  belongs_to :location

  validates :level, :inclusion => 1..5

  alias_attribute :empresa, :company
  alias_attribute :titulo, :title
  alias_attribute :descricao, :description
  alias_attribute :nivel, :level
  alias_attribute :localizacao, :location

end
