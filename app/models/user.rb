class User < ApplicationRecord
  belongs_to :location
  has_many :applications, :dependent => :destroy

  validates :level, :inclusion => 1..5

  alias_attribute :nome, :name
  alias_attribute :profissao, :job_description
  alias_attribute :nivel, :level
  alias_attribute :localizacao, :location

end
