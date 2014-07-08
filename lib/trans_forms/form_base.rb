require 'virtus'
require 'active_model/naming'
require 'active_model/conversion'
require 'active_model/translation'
require 'active_model/validations'
require 'active_model/validations/callbacks'

module TransForms
  class FormBase
    include Virtus.model

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    include TransForms::Callbacks

    def save
      if valid?
        run_transaction
      else
        false
      end
    end

    def save!
      save || (raise ActiveRecord::RecordInvalid)
    end

    # ActiveModel support
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
