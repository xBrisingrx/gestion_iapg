require 'rails_helper'

RSpec.describe CourseType, type: :model do
  subject { build(:course_type) }

  describe "validations" do
    it { is_expected.to be_valid }
    it { is_expected.to belong_to(:room) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:min_quota) }
    it { is_expected.to validate_presence_of(:max_quota) }
    it { is_expected.to validate_presence_of(:min_score) }
    it { is_expected.to validate_presence_of(:max_score) }
    it { is_expected.to validate_presence_of(:passing_score) }
    it { is_expected.to validate_presence_of(:number_of_repeat) }
    it { is_expected.to validate_presence_of(:fleet) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_uniqueness_of(:name).with_message("Este tipo de curso ya se encuentra registado.") }
  end
end
