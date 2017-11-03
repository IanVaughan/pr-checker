class Project < ActiveRecord::Base
  validates :id, presence: true
  has_many :merge_requests
  has_many :pipelines
end
