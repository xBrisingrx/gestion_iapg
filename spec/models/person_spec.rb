require 'rails_helper'

RSpec.describe Person, type: :model do
  # por defecto RSpec declara una variable subject en cada archivo spec
  # esta se genera con el objeto que estamos testeando (lo infiere con el nombre del archivo y el tipo de spec que estamos realizando)
  # y la podemos usar con los metodos que no indicamos el objeto , en este caso los is_expected.to
  # aca la sobreescribimos con los datos de nuestra factory
  subject { build(:person) }

  describe "validations" do
    it { is_expected.to be_valid }
    it { is_expected.to belong_to(:city).optional }
    it { is_expected.to belong_to(:province).optional }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:cuil) }
    it { is_expected.to validate_presence_of(:birthdate) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_presence_of(:celphone) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:direction) }
    it { is_expected.to validate_uniqueness_of(:cuil).with_message("Ya existe una persona registrada con este cuil.") }
  end

  describe "#fullname" do
    let(:person) { build(:person) }
    it "return last_name + name" do
      expect(person.fullname).to eq("Bromson Eragon")
    end
  end

  describe "#disable" do
    let(:person) { build(:person) }
    it "change active to false" do
      person.disable
      expect(person.active).to eq(false)
    end
  end

  describe "scope" do
    describe ".active" do
      let(:person1) { create(:person) }
      let(:person2) { create(:person, :inactive) }

      before do
        [ person1, person2 ]
      end
      it "return only active people" do
        expect(Person.actives).to eq([ person1 ])
      end
    end
  end
end
