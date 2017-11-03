class Pipeline  < ActiveRecord::Base
  belongs_to :project
  has_many :jobs
end
