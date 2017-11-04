class Pipeline  < ActiveRecord::Base
  validates :id, :sha, :ref, presence: true, uniqueness: true
  validates :status, presence: true
  belongs_to :project
  has_many :jobs
end
