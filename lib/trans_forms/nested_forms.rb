module TransForms
  module NestedForms
    extend ActiveSupport::Concern

    module ClassMethods

      # Call this method from any Form class that uses a Hash attribute to
      # process nested form models. It will include a number of methods
      # to more efficiently go through params and records.
      def has_nested_forms
        include TransForms::NestedForms::Active
      end

    end

    module Active
      extend ActiveSupport::Concern

    protected

      # A method that can be used to iterate through a Hash value that is
      # structured the way Rails form helper +fields_for+ will create.
      #
      # Example:
      #
      #   # Given the following Hash:
      #   attr = { '0' => { name: 'John' }, '0' => { name: 'Peter' } }
      #
      #   # It can be processed like this:
      #   each_nested_hash_for attr do |nested_hash|
      #     name = nested_hash['name']
      #     # Do something with the name, like create multiple Contact
      #     # records
      #   end
      #
      def each_nested_hash_for(attr, &block)
        if attr.is_a?(Hash)
          attr.values.each do |v|
            if v.is_a?(Hash)
              block.call(v.stringify_keys)
            end
          end
        end
      end

      # A method that can be used to make sure that there are at least
      # one nested hash that has a present value. Useful for validating
      # an attribute when there needs to be at least one association
      # created together with a main record.
      def any_nested_hash_for?(attr)
        attr.is_a?(Hash) && attr.values.detect { |v|
          v.is_a?(Hash) && v.values.detect(&:present?).present?
        }.present?
      end

      def find_from!(collection, identifier, find_by = :id)
        if identifier.present?
          collection.detect { |instance| instance.send(find_by) == identifier.to_i } || (raise NotFoundFromError)
        else
          raise NotFoundFromError
        end
      end

    end

  end
end

TransForms::FormBase.send(:include, TransForms::NestedForms)
