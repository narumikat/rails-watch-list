class List < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks
  has_many :reviews, dependent: :destroy

  has_one_attached :photo

  validates :name, presence: true, uniqueness: true
  validates :image_url, presence: true, unless: -> { photo.present? }
  validates :photo, presence: true, unless: -> { image_url.present? }

  validate :image_url_or_photo_present

  before_save :capitalize_name

  private

  def capitalize_name
    self.name = name.capitalize if name.present?
  end

  def image_url_or_photo_present
    if image_url.blank? && photo.blank?
      errors.add(:base, "Either image_url or photo must be present")
    end
  end
end
