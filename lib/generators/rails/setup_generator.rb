module Rails
  module Generators
    class SetupGenerator < Base
      source_root File.expand_path('../templates', __FILE__)

      def create_form_file
        template 'application_trans_form.rb', File.join('app/trans_forms', 'application_trans_form.rb')
      end

      hook_for :test_framework

    end
  end
end
