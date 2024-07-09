class List < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks
  has_many :reviews, dependent: :destroy

  has_one_attached :photo

  validates :name, presence: true, uniqueness: true
  # validates :image_url, presence: true
  validates :photo, presence: true

  before_save :capitalize_name

  private

  def capitalize_name
    self.name = name.capitalize if name.present?
  end
end
