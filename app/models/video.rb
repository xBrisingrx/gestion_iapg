class Video < ApplicationRecord
  has_many :module_videos
  scope :actives, -> { where(active: true) }

  def disable
    self.update(active: false)
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "title" ]
  end
end
