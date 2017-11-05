class MergeRequest < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  validates :iid, :title, :state, :web_url, presence: true
  belongs_to :project
  has_many :notes
end
