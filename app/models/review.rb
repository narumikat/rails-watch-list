class Review < ApplicationRecord
  belongs_to :list
  belongs_to :movie

  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }, numericality: { only_integer: true }
end
