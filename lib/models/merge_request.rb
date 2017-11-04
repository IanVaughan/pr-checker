class MergeRequest < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  belongs_to :project
end
