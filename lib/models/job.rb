class Job < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  validates :status, :stage, :name, :ref, :tag, :started_at, :finished_at, presence: true
  belongs_to :pipeline
end
