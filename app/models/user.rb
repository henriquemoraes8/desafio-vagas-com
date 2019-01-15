class User < ApplicationRecord
  belongs_to :location
  has_many :applications, :dependent => :destroy
  has_many :applied_jobs, :through => :applications, source: :job

  validates :level, numericality: { only_integer: true, greater_than: 0, less_than: 6 }

  validates_presence_of :name, :job_description, allow_blank: false

  alias_attribute :nome, :name
  alias_attribute :profissao, :job_description
  alias_attribute :nivel, :level
  alias_attribute :localizacao, :location

end
