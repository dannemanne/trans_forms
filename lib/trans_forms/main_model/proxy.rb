module TransForms
  module MainModel
    module Proxy
      extend ActiveSupport::Concern
      # A module that adds functionality to delegate certain
      # methods to the main model. This is done to make forms
      # and controllers handle the form model as if it were
      # the main model itself

      # Dependency for the Proxy Module. Usually this is already
      # included before Proxy is included, but we make sure it
      # is present by including it from here as well.
      include ::TransForms::MainModel::Active

      def persisted?
        respond_to?(:main_instance) && main_instance && main_instance.persisted?
      end

      # In case the Main Model has implemented custom +to_param+ method, we need
      # to make sure we use it here as well
      def to_param
        respond_to?(:main_instance) && main_instance && main_instance.to_param || super
      end

      # Returns an Enumerable of all key attributes of the main instanceif any is
      # set, regardless if the object is persisted or not. Returns +nil+ if there
      # is no main_instance or if main_instance have no key attributes.
      #
      #   class UserForm < TransForms::BaseForm
      #     set_main_model :user, proxy: true
      #   end
      #
      #   form = UserForm.new
      #   form.to_key # => nil
      #
      #   form.user = User.new
      #   form.to_key # => nil
      #
      #   form.user.save # => true
      #   form.to_key # => [1]
      def to_key
        respond_to?(:main_instance) && main_instance && main_instance.to_key
      end

      module ClassMethods
        RESERVED_COLUMN_NAMES = %w(id created_at updated_at)
        REJECT_COLUMN_PROC = Proc.new { |c| RESERVED_COLUMN_NAMES.include?(c.name) }

        # Configures the proxy setup. Called from +set_main_model+ when
        # the option :proxy was supplied. +proxy_options+ will be the value
        # for that :proxy key.
        #
        # If +proxy
        def configure_proxy(proxy_options)
          if proxy_options.is_a?(Hash)
            set_proxy_attributes proxy_options[:attributes] if proxy_options[:attributes]
          end
        end

        # If +attributes+ is the Boolean value TRUE then we will proxy all
        # of the attributes from the main_model class except for a few
        # reserved attributes.
        #
        # But if +attributes+ is an array then we only proxy those attributes
        # listed in the array. If any of the attributes listed in the array is
        # not an actual attribute of the main model then an Error will be
        # raised.
        def set_proxy_attributes(attributes)
          if attributes == :all
            proxy_columns main_class.columns.reject(&REJECT_COLUMN_PROC)
          elsif attributes.is_a?(Array)
            attr_names = attributes.map(&:to_s)
            proxy_columns main_class.columns.reject(&REJECT_COLUMN_PROC).select { |c| attr_names.include?(c.name) }
          end
        end

        # Given a set of ActiveRecord Columns, will setup attributes according
        # to the Virtus standard that will have the default value of the main
        # instance record.
        def proxy_columns(columns)
          columns.each do |column|
            if (type = column_type(column.type)).present?
              # When setting the default value, note that +main_instance+ might be nil, so we have to use +try+
              attribute column.name,  type, default: proc { |f| f.main_instance.try(column.name) }
            end
          end
        end

        # Returns a Class for the specific column type.
        def column_type(type)
          case type
            when :integer                     then Integer
            when :float, :decimal             then Float
            when :string, :text               then String
            when :datetime, :timestamp, :time then DateTime
            when :date                        then Date
            when :boolean                     then Virtus::Attribute::Boolean # Boolean is not a standard Ruby class
          end
        end

        # Returns an ActiveModel::Name object for module. It can be
        # used to retrieve all kinds of naming-related information
        # (See ActiveModel::Name for more information).
        #
        #   class PostForm < TransForms::FormBase
        #     set_main_model :post, proxy: true
        #   end
        #
        #   PostForm.model_name          # => Post
        #   PostForm.model_name.class    # => ActiveModel::Name
        #   PostForm.model_name.singular # => "post"
        #   PostForm.model_name.plural   # => "posts"
        def model_name
          @_model_name ||= begin
            klass = respond_to?(:main_class) ? main_class : self

            namespace = klass.parents.detect do |n|
              n.respond_to?(:use_relative_model_naming?) && n.use_relative_model_naming?
            end
            ActiveModel::Name.new(klass, namespace)
          end
        end

      end
    end
  end
end
