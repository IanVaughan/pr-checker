class Branch < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :project
end
