class Job < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  validates :status, :stage, :name, :ref, :tag, presence: true
  belongs_to :pipeline
end
