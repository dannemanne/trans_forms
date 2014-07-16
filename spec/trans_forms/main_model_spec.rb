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

      describe 'option[:proxy]' do
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
        it 'defines attributes for all non-reserved column names of the main model' do
          # ATTR_ARG is defined in test model, just to make
          # sure we test with a correct model.
          expect(UserProxyAllModel::ATTR_ARG).to eq :all
          expect(UserProxyAllModel.main_class).to eq User
          expect(UserProxyAllModel.attribute_set.each.map(&:name).map(&:to_s)).to eq User.columns.reject { |c| %w(id created_at updated_at).include?(c.name) }.map(&:name)
        end
        it 'defines attributes for the specified columns' do
          # ATTR_ARG is defined in test model, just to make
          # sure we test with a correct model.
          expect(UserProxySelectModel::ATTR_ARG).to eq %w(name)
          expect(UserProxySelectModel.main_class).to eq User
          expect(UserProxySelectModel.attribute_set.each.map(&:name).map(&:to_s)).to eq %w(name)
        end
        it 'sets the default value of an attribute to the corresponding attribute of the main instance' do
          form = UserProxyAllModel.new(model: user)
          expect(form.name).to eq user.name
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
