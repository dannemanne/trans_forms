require 'active_support/ordered_hash'
require 'active_model/errors'

module TransForms
  class FormErrors < ActiveModel::Errors

    def initialize(base)
      @base = base
      @messages = {}
    end

    def error_models
      # Cannot cache these models because method can be called before main
      # instance has been set.
      [@base.main_instance.try(:errors)].compact
    end

    def clear
      error_models.each(&:clear)
      super
    end

    def [](key)
      arr = super(key)

      error_models.each { |error_model|
        error_model[key].each do |msg|
          arr << msg
        end
      }

      arr
    end

  end
end
