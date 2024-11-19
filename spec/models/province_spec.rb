require 'rails_helper'

# Ayuda memoria

# RSpec.describe es un grupo de ejemplo que describe que estamos testeando (en nuestro caso el modelo Province) y el comportamiento
# que deseamos y como debe usarse

# SPEC es la abreviacion de specification, especificamos el comportamiento deseado de un fragmento de codigo 

# El test valida que el fragmento de codigo funciona correctamente.

RSpec.describe Province, type: :model do
  subject { build(:province) }
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).with_message("Ya existe una provincia registrada con este nombre") }
  end
end
