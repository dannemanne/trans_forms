require 'active_support/concern'

module TransForms
  module MainModel
    extend ActiveSupport::Concern

    module ClassMethods

      # This method will extend the BaseForm functionality with the
      # TransForms::MainModel::Active module.
      def set_main_models(*models)
        unless self < TransForms::MainModel::Active
          include TransForms::MainModel::Active

          class_attribute :main_models
          self.main_models = []
        end

        self.main_models += models

        models.each do |model|
          attr_accessor model
        end
      end

    end

    module Active
      extend ActiveSupport::Concern

      included do
        after_save_on_callback :assert_record_on_error
      end

      # Called from FormError to collect error messages from all possible
      # models involved in the form transation.
      def main_instances
        main_models.map { |record_name| send(record_name) }.compact
      end

      # Combines the errors from the FormModel as well as the main model instances
      def errors
        @errors ||= FormErrors.new(self, super)
      end

      # This method is assigned to the after_save_on_error callback
      #
      # If an error was raised in a create! statement then the variable might not
      # have been assigned and would prevent error messages to be displayed. This
      # makes sure that the instance that raised the error will be assigned if it
      # would have been the main model.
      def assert_record_on_error
        if e.respond_to?(:record) && e.record.present?
          record_name = e.record.class.name.underscore
          if main_models.is_a?(Array) && main_models.include?(record_name.to_sym) && send(record_name).nil?
            send("#{record_name}=", e.record)
          end
        end
      end

      module ClassMethods

        # This method will initialize the form model with a specific record
        # set as the main model.
        def new_in_model(model, params = {})
          new(params.merge(model: model))
        end

        # In it's default implementation, this method will look at the class name
        # and try to match it to an attribute defined in the form model. If a match
        # is found, then it will assign the model to that attribute.
        #
        # This method is encouraged to overwrite when there is custom conditions
        # for how to handle the assignments.
        #
        # For example:
        #
        #   class UserUpdater < ApplicationTransForm
        #     attr_accessor :admin
        #     set_main_model :user
        #
        #     def model=(model)
        #       if model.role == :admin
        #         self.admin = model
        #       else
        #         self.user = model
        #       end
        #     end
        #
        #     # ...
        #   end
        #
        def model=(model)
          attr = model.class.model_name.underscore
          if respond_to?("#{attr}=")
            send("#{attr}=", model)
          else
            raise TransForms::NotImplementedError
          end
        end

      end
    end
  end
end

TransForms::FormBase.send(:include, TransForms::MainModel)
