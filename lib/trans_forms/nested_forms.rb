module TransForms
  module NestedForms
    extend ActiveSupport::Concern

    module ClassMethods

      # Call this method from any Form class that uses a Hash attribute to
      # process nested form models. It will include a number of methods
      # to more efficiently go through params and records.
      def self.has_nested_forms
        include TransForms::NestedForms::Active
      end

    end

    module Active
      extend ActiveSupport::Concern

      def each_nested_hash_for(attr, &block)
        if attr.is_a?(Hash)
          attr.values.each do |v|
            if v.is_a?(Hash)
              block.call(v.stringify_keys)
            end
          end
        end
      end

      def any_nested_hash_for?(attr)
        if attr.is_a?(Hash)
          attr.values.detect { |v| v.is_a?(Hash) && v.values.detect(&:present?).present? }.present?
        else
          false
        end
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
