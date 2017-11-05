class ProjectHook < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  validates :url, presence: true
  belongs_to :project
end
