require 'spec_helper'

module TransForms
  module MainModel
    describe Proxy do
      describe 'model_name' do
        it 'returns an ActiveModel::Name instance for the main_model instead of form model' do
          expect(ProxyModel.main_model).to eq :user
          expect(ProxyModel.name).to eq 'ProxyModel'
          expect(ProxyModel.model_name).to eq 'User'
        end
      end

      describe 'column_type' do
        it 'returns a Class representing the type of an ActiveRecord Column' do
          expect(ProxyModel.column_type(:integer)).to   eq Integer
          expect(ProxyModel.column_type(:string)).to    eq String
          expect(ProxyModel.column_type(:text)).to      eq String
          expect(ProxyModel.column_type(:datetime)).to  eq DateTime
          expect(ProxyModel.column_type(:date)).to      eq Date
          expect(ProxyModel.column_type(:float)).to     eq Float
          expect(ProxyModel.column_type(:decimal)).to   eq Float
          expect(ProxyModel.column_type(:boolean)).to   eq Virtus::Attribute::Boolean
        end
      end
    end
  end
end
