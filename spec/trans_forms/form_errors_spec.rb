require 'spec_helper'

module TransForms
  describe FormErrors do
    describe '#error_models' do
      it 'does not raise an error when called on a form model without a main_instance' do
        form = UserUpdater.new
        expect(form.main_model).to eq(:user)
        expect(form.main_instance).to be nil
        expect { form.errors.error_models }.not_to raise_error
      end
    end
  end
end
