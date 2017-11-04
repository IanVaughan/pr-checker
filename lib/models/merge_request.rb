class MergeRequest < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  validates :iid, :title, :description, :state, :web_url, presence: true
  belongs_to :project
end
