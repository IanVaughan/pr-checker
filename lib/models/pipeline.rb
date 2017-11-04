class Pipeline  < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  belongs_to :project
  has_many :jobs
end
