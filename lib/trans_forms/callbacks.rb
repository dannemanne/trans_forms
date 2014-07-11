require 'active_support/concern'

module TransForms
  module Callbacks
    extend ActiveSupport::Concern

    included do
      class_attribute :_tf_cb
    end

    def after_save_on_error_callback(active_record_error)
      if _tf_cb && _tf_cb[:after_save_on_error].is_a?(Array)
        _tf_cb[:after_save_on_error].each do |method|
          send method, active_record_error
        end
      end
    end

    module ClassMethods

      def after_save_on_error(*args)
        self._tf_cb ||= {}
        _tf_cb[:after_save_on_error] ||= []
        _tf_cb[:after_save_on_error] += args
      end

    end

  end
end
