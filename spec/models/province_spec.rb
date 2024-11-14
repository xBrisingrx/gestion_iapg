require 'rails_helper'

RSpec.describe Province, type: :model do
  subject { build(:province) }
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).with_message("Ya existe una provincia registrada con este nombre") }
  end
end
