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

    def save
      valid? && run_transaction
    end

    def save!
      save || (raise ActiveRecord::RecordInvalid)
    end

    # ActiveModel support.
    # Note that these methods will be overwritten if the +proxy+ option
    # is enabled in the call to +set_main_model+
    def persisted?; false end
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
    rescue ActiveRecord::ActiveRecordError => e
      # Triggers callback
      after_save_on_error_callback e
      false
    end

  end
end
