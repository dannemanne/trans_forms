module TransForms
  module MainModel
    module Proxy
      extend ActiveSupport::Concern
      # A module that adds functionality to delegate certain
      # methods to the main model. This is done to make forms
      # and controllers handle the form model as if it were
      # the main model itself

      def persisted?
        respond_to?(:main_instance) && main_instance && main_instance.persisted?
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
            klass = respond_to?(:main_model) ? main_model.to_s.classify.constantize : self

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
