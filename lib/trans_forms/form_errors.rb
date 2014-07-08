module TransForms
  class FormErrors
    attr_accessor :form_model, :original

    def initialize(form_model, original)
      self.form_model, self.original = form_model, original
    end

    def error_models
      [original] + form_model.main_instances.map(&:errors)
    end

    def full_messages
      original.full_messages
    end

    def clear
      error_models.each do |em|
        em.clear
      end
    end

    def [](key)
      error_models.inject([]) { |acc, error_model|
        acc += (error_model[key])
      }
    end

    def empty?
      error_models.all?(&:empty?)
    end

    def method_missing(m, *args, &block)
      original.send(m, *args, &block)
    end

  end
end
