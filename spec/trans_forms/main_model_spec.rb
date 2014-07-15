require 'spec_helper'

module TransForms
  describe MainModel do
    let(:user) { User.create(name: 'John') }
    let(:phone_number) { PhoneNumber.create(user_id: user.id, number: '+1-555-MY-NUMBER') }

    describe 'set_main_model' do
      it 'defines accessor attributes for main model and stores them in a class attribute' do
        form = MainModelModel.new
        expect{ form.user }.to raise_error
        expect{ form.user = User.new }.to raise_error

        MainModelModel.set_main_model :user
        form = MainModelModel.new
        expect{ form.user }.not_to raise_error
        expect{ form.user = User.new }.not_to raise_error

        expect(MainModelModel.main_model).to eq :user
      end

      describe 'option { proxy: true }' do
        it 'proxies +model_name+ method to the main_model' do
          expect(UserProxyModel.main_model).to eq :user
          expect(UserProxyModel.name).to eq 'UserProxyModel'
          expect(UserProxyModel.model_name).to eq 'User'
        end
        it 'proxies +persisted?+ method to the main_instance' do
          form = UserProxyModel.new(user: User.new)
          expect(form.user.persisted?).to be false
          expect(form.persisted?).to be false

          form.user = User.create!(name: 'John Doe')
          expect(form.user.persisted?).to be true
          expect(form.persisted?).to be true
        end
        it 'proxies +to_key+ method to the main_instance' do
          form = UserProxyModel.new(user: User.new)
          expect(form.user.to_key).to be nil
          expect(form.to_key).to be nil

          form.user = User.create!(name: 'John Doe')
          expect(form.user.to_key).not_to be nil
          expect(form.to_key).to eq form.user.to_key
        end
      end
    end

    describe 'model accessor' do
      it 'can initialize a form model and automatically set the accessor defined by main_model' do
        expect(UserUpdater.main_model).to eq :user
        form = UserUpdater.new(model: user)
        expect(form.user).to eq user
      end

      it 'raises an error if the model supplied is not the type of main model' do
        expect(UserUpdater.main_model).to eq :user
        expect { UserUpdater.new(model: phone_number) }.to raise_error
      end
    end
  end

end
