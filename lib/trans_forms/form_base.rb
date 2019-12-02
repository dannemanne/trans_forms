require 'virtus'
require 'active_support'
require 'active_model'

module TransForms
  class FormBase
    include Virtus.model

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    include TransForms::Callbacks

    attr_accessor :_last_error

    def save
      valid? && run_transaction
    end

    def save!
      valid? || raise(ActiveRecord::RecordInvalid.new(self))
      save || (_last_error && raise(_last_error) || raise(ActiveRecord::RecordNotSaved))
    end

    # ActiveModel support.
    # Note that these methods will be overwritten if the +proxy+ option
    # is enabled in the call to +set_main_model+
    def persisted?; false end
    def new_record?; !persisted? end
    def to_key; nil end

  protected
    def self.transaction(&block)
      class_attribute :_transaction
      self._transaction = block
    end

    def run_transaction
      ActiveRecord::Base.transaction do
        instance_eval &_transaction
        true
      end

    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved, ActiveRecord::RecordNotDestroyed => e
      handle_transaction_error e do
        if e.record.present? && errors != e.record.errors
          e.record.errors.each do |attribute, message|
            errors.add(attribute, message) unless Array(errors[attribute]).include? message
          end
        end
      end

    rescue ActiveRecord::ActiveRecordError => e
      handle_transaction_error e
    end

    def handle_transaction_error(e)
      self._last_error = e

      yield if block_given?

      after_save_on_error_callback e
      false
    end

    # A method to to use when you want to redirect any errors raised to a
    # specific attribute. It requires a block and any ActiveRecordErrors
    # that are raised within this block will be assigned to the Form Models
    # Errors instance for the key specified by +attr+.
    #
    #   class ArticleCreator < ApplicationTransForm
    #     attribute :author_name
    #     ...
    #
    #     transaction do
    #       all_errors_to(:author_name) do
    #         # If this following statement raises an ActiveRecordError, then
    #         # that error message will be stored on the attribute :author_name
    #         Author.create!(name: author_name)
    #       end
    #
    #       ...
    #     end
    #   end
    #
    def all_errors_to(attr)
      raise 'No block given' unless block_given?
      yield
    rescue ActiveRecord::ActiveRecordError => e
      errors[attr] = e.message
      raise e
    end

  end
end
