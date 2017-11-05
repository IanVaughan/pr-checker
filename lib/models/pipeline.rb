class Pipeline  < ActiveRecord::Base
  # validates :id, :sha, :ref, presence: true, uniqueness: true
  validates :id, presence: true, uniqueness: true
  validates :sha, :ref, presence: true # uniqueness only on project
  validates :status, presence: true
  belongs_to :project
  has_many :jobs
end
