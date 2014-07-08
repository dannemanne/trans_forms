require 'spec_helper'

module TransForms
  describe Callbacks do

    describe 'after_save_on_error' do
      it 'registers a method to be called when a transaction is rolled back' do
        attr = { name1: 'John', name2: 'John' }
        form = CallbackForm.new(attr)

        expect(form).to be_valid
        expect(form.save).to be false
        expect(form.i_was_called).to be true
      end

      it 'will not call registered method if form model was invalid' do
        attr = { name1: '', name2: '' }
        form = CallbackForm.new(attr)

        expect(form).not_to be_valid
        expect(form.save).to be false
        expect(form.i_was_called).not_to be true
      end
    end
  end

end
