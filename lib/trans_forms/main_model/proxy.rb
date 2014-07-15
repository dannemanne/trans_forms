module TransForms
  module MainModel
    module Proxy
      extend ActiveSupport::Concern
      # A module that adds functionality to delegate certain
      # methods to the main model. This is done to make forms
      # and controllers handle the form model as if it were
      # the main model itself

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
