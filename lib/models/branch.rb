class Branch < ActiveRecord::Base
  validates :name, presence: true #, uniqueness: true only per project!
  belongs_to :project
end
