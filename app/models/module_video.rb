class ModuleVideo < ApplicationRecord
  belongs_to :exam_module
  belongs_to :video
  scope :actives, -> { where(active: true) }

  validates :video_order, presence: true

  # before_validation :set_video_order

  def disable
    self.update(active: false)
  end

  private
  def set_video_order
    video_order = self.exam_module.module_videos.actives.order(video_order: :desc)
    if video_order.blank?
      self.video_order = 1
    else
      self.video_order = video_order.first.video_order + 1
    end
  end
end
