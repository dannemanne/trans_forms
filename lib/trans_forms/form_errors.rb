require 'active_support/ordered_hash'
require 'active_model/errors'

module TransForms
  class FormErrors < ActiveModel::Errors
    attr_accessor :form_model, :original

    def initialize(form_model, original)
      @base = form_model
      self.form_model, self.original = form_model, original
    end

    def initialize_dup(other)
      @messages = other.messages.dup
    end

    def error_models
      # Cannot cache these models because method can be called before main
      # instance has been set.
      [original, form_model.main_instance.try(:errors)].compact
    end

    # Reflects the combined result of the FormModels messages as well as
    # the messages from each main instance's error model
    def messages
      error_models.inject(ActiveSupport::OrderedHash.new) { |acc, error_model|
        error_model.messages.each { |attr, msg_array|
          acc[attr] ||= []
          acc[attr] += msg_array
          acc
        }
        acc
      }
    end

    def clear
      error_models.each(&:clear)
    end

    # Get messages for +key+
    def get(key)
      messages[key]
      error_models.inject([]) { |acc, error_model|
        acc + error_model.get(key)
      }
    end

    # Set messages for +key+ to +value+
    def set(key, value)
      original.set(key, value)
    end

    # Delete messages for +key+
    def delete(key)
      original.delete(key)
    end

    def [](key)
      error_models.inject([]) { |acc, error_model|
        acc + error_model[key]
      }
    end

    # Adds to the supplied attribute the supplied error message.
    #
    #   p.errors[:name] = "must be set"
    #   p.errors[:name] # => ['must be set']
    def []=(attribute, error)
      original[attribute] = error
    end

    def empty?
      error_models.all?(&:empty?)
    end

  end
end
