class Job < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  belongs_to :pipeline
end
