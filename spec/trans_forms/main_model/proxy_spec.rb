require 'spec_helper'

module TransForms
  module MainModel
    describe Proxy do
      describe 'model_name' do
        it 'returns an ActiveModel::Name instance for the main_model instead of form model' do
          expect(ProxyModel.main_model).to eq :user
          expect(ProxyModel.name).to eq 'ProxyModel'
          expect(ProxyModel.model_name.name).to eq 'User'
        end
      end
    end
  end
end
