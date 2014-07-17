require 'spec_helper'

module TransForms
  describe FormErrors do
    describe '#error_models' do
      it 'returns an array with only one error model when main_instance is nil' do
        form = UserUpdater.new
        expect(form.main_model).to eq(:user)
        expect(form.main_instance).to be nil
        expect(form.errors.error_models.length).to eq 1
      end
      it 'returns an array with two error models when main_instance is present, one of them is the models errors' do
        user = User.new
        form = UserUpdater.new(model: user)
        expect(form.main_instance).to be_present
        expect(form.errors.error_models.length).to eq 2
        expect(form.errors.error_models).to include user.errors
      end
    end

    describe '#clear' do
      it 'clears the errors for both the form model and the main model' do
        user = User.new
        expect(user.valid?).to be false
        expect(user.errors).to be_any

        form = UserUpdater.new(model: user)
        expect(form.valid?).to be false
        expect(form.errors.original).to be_any

        form.errors.clear

        expect(user.errors).not_to be_any
        expect(form.errors.original).not_to be_any
      end
    end

    describe '#[](key)' do
      it 'returns an array containing the messages from all error_models for that key' do
        user = User.new
        expect(user.valid?).to be false
        expect(user.errors[:name]).to be_any

        form = UserUpdater.new(model: user)
        expect(form.valid?).to be false
        expect(form.errors.original[:name]).to be_any

        expect(form.errors[:name]).to eq(form.errors.original[:name] + user.errors[:name])
      end
    end

    describe '#empty?' do
      it 'return true if all error models are empty' do
        user = User.new(name: 'John Doe')
        expect(user.valid?).to be true
        expect(user.errors).to be_empty

        form = UserUpdater.new(model: user, name: 'John Doe')
        expect(form.valid?).to be true
        expect(form.errors.original).to be_empty

        expect(form.errors.empty?).to be true
      end

      it 'return false if the forms original error model is not empty' do
        user = User.new(name: 'John Doe')
        expect(user.valid?).to be true
        expect(user.errors).to be_empty

        form = UserUpdater.new(model: user)
        expect(form.valid?).to be false
        expect(form.errors.original).not_to be_empty

        expect(form.errors.empty?).to be false
      end

      it 'return false if the main instance error model is not empty' do
        user = User.new
        expect(user.valid?).to be false
        expect(user.errors).not_to be_empty

        form = UserUpdater.new(name: 'John Doe')
        expect(form.valid?).to be true
        expect(form.errors.original).to be_empty

        # Need to assign the user after the form has been validated, otherwise
        # the user's errors will be cleared by the form model upon validation
        form.user = user

        expect(form.errors.empty?).to be false
      end
    end
  end
end
