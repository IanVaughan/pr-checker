class User < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  validates :name, :email, presence: true
end
