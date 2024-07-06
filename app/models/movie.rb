class Movie < ApplicationRecord
  has_many :bookmarks
  has_many :reviews

  validates :title, :overview, uniqueness: true
  validates :title, :overview, presence: true

end
