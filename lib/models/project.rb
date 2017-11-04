class Project < ActiveRecord::Base
  validates :id, :name_with_namespace, :path_with_namespace, presence: true, uniqueness: true
  has_many :merge_requests
  has_many :pipelines
  has_many :branches
end
