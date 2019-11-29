module TransForms
  module MainModel
    extend ActiveSupport::Concern

    module ClassMethods

      # This method will extend the BaseForm functionality with the
      # TransForms::MainModel::Active module.
      #
      # The +model+ argument is a symbol in the underscore format
      # of a Class name, i.e. +:post+ or +:product_group+
      #
      # The +options+ argument is a Hash that can have the following
      # options set:
      #
      # +:proxy+
      #   With proxy defined, the method +model_name+, +to_key+ and
      #   +persisted?+ will refer to the main_model and main_instance
      #   instead of the Form Model.
      #
      #   class PostForm < TransForms::FormBase
      #     set_main_model :post, proxy: true
      #   end
      #
      #   You can also configure the proxy further by defining the
      #   +attributes+ option inside the proxy. If the value is +:all+
      #   then it will define all the columns of the main model. But
      #   you can also set the value to an array with the names of the
      #   columns you wish to proxy:
      #
      #   class PostForm < TransForms::FormBase
      #     set_main_model :post, proxy: { attributes: :all }
      #   end
      #
      #   class PostForm < TransForms::FormBase
      #     set_main_model :post, proxy: { attributes: %w(title body status) }
      #   end
      def set_main_model(model, options = {})
        include TransForms::MainModel::Active

        # Stores the main_model record in a class_attribute
        self.main_model = model

        # If model is in namespace then it might be needed to specify manually
        self._class_name = options[:class_name] if options.has_key?(:class_name)

        # Defines an instance accessor for the main_model
        attr_accessor model

        # Implements proxy module that overwrites model_name method
        # to instead return an ActiveModel::Mame class for the
        # main_model class
        if options[:proxy]
          include TransForms::MainModel::Proxy

          configure_proxy options[:proxy]
        end
      end

    end

    module Active
      extend ActiveSupport::Concern

      included do
        # Since the after_save_on_error is not part of this module, we make sure
        # that the methods exist before calling it. It should not be necessary since
        # the Callbacks module is included by default in the FormBase, but added
        # anyway. If this module is included manually (like in one of the specs) then
        # it prevents any error to occur.
        after_save_on_error :assert_record_on_error if respond_to?(:after_save_on_error)

        # Adding class attributes to store model and options for each usage.
        class_attribute :main_model, :_class_name
      end

      # Instance method to retrieve the current main model instance
      def main_instance
        send main_model
      end

      # Combines the errors from the FormModel as well as the main model instances
      def errors
        @errors ||= ActiveModel::Errors.new(self)
        if respond_to?(:main_instance) && main_instance && main_instance.errors.any?
          main_instance.errors
        else
          @errors
        end
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
        element = to_element(model)
        if respond_to?("#{element}=")
          send("#{element}=", model)
        else
          raise TransForms::NotImplementedError
        end
      end

      protected

      # This method is assigned to the after_save_on_error callback
      #
      # If an error was raised in a create! statement then the variable might not
      # have been assigned and would prevent error messages to be displayed. This
      # makes sure that the instance that raised the error will be assigned if it
      # would have been the main model.
      def assert_record_on_error(e)
        if e.respond_to?(:record) && e.record.present?
          element = to_element(e.record)
          if main_model == element.to_sym && send(element).nil?
            send("#{element}=", e.record)
          end
        end
      end

      # A method to retrieve the underscored version of a record's class name.
      # The procedure is slightly different in Rails 3 and Rails 4, that's what
      # this method takes into consideration.
      def to_element(record)
        if record.class.model_name.is_a?(ActiveModel::Name)
          record.class.model_name.element
        else
          record.class.model_name.param_key
        end
      end


      module ClassMethods

        # Returns the class of the main_model
        def main_class
          @main_class ||=
              if _class_name.present?
                _class_name.constantize
              else
                main_model.to_s.classify.constantize
              end
        end

      end

    end
  end
end

TransForms::FormBase.send(:include, TransForms::MainModel)
