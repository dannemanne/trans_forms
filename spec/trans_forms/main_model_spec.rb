require 'spec_helper'

module TransForms
  describe MainModel do
    let(:user) { User.create(name: 'John') }
    let(:phone_number) { PhoneNumber.create(user_id: user.id, number: '+1-555-MY-NUMBER') }

    describe 'set_main_models' do
      it 'defines accessor attributes for each model and stores them in a class attribute' do
        form = MainModelModel.new
        expect{ form.user }.to raise_error
        expect{ form.user = User.new }.to raise_error

        MainModelModel.set_main_models :user
        form = MainModelModel.new
        expect{ form.user }.not_to raise_error
        expect{ form.user = User.new }.not_to raise_error

        expect(MainModelModel.main_models).to eq [:user]
      end
    end

    describe 'model accessor' do
      it 'can initialize a form model and automatically set the accessor defined by main_models' do
        expect(UserUpdater.main_models).to eq [:user]
        form = UserUpdater.new(model: user)
        expect(form.user).to eq user
      end

      it 'raises an error if the model supplied is not of a type included in main_models' do
        expect(UserUpdater.main_models).to eq [:user]
        expect { UserUpdater.new(model: phone_number) }.to raise_error
      end
    end

    describe '#main_instances' do
      it 'returns an array of all values set on the accessors defined by set_main_model, excluding nil values' do
        expect(MultipleRecordsMainModel.main_models).to eq [:user, :phone_number]

        form = MultipleRecordsMainModel.new(model: user)
        expect(form.user).to eq user
        expect(form.phone_number).to be_nil
        expect(form.main_instances).to eq [user]

        form.phone_number = phone_number
        expect(form.user).to eq user
        expect(form.phone_number).to eq phone_number
        expect(form.main_instances).to eq [user, phone_number]

        form.user = nil
        expect(form.user).to be_nil
        expect(form.phone_number).to eq phone_number
        expect(form.main_instances).to eq [phone_number]
      end
    end

  end

end
