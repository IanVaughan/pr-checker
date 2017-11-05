class Note  < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  belongs_to :merge_request
end
