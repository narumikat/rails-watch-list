class Movie < ApplicationRecord
  has_many :bookmarks
  has_many :reviews
  has_many :lists, through: :bookmarks

  validates :title, :overview, uniqueness: true
  validates :title, :overview, presence: true
  validates :backdrop_path, presence: true
  validates :rating, presence: true, numericality: true
end
