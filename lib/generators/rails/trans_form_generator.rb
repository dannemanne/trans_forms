module Rails
  module Generators
    class TransFormGenerator < NamedBase
      source_root File.expand_path('../templates', __FILE__)
      check_class_collision

      class_option :parent, type: :string, desc: 'The parent class for the generated form model'

      def create_form_file
        template 'trans_form.rb', File.join('app/trans_forms', class_path, "#{file_name}.rb")
      end

      hook_for :test_framework

    private

      def parent_class_name
        options.fetch('parent') do
          begin
            require 'application_trans_form'
            ApplicationTransForm
          rescue LoadError
            'TransForms::FormBase'
          end
        end
      end

      # Rails 3.0.X compatibility, copied from https://github.com/jnunemaker/mongomapper/pull/385/files#L1R32
      unless methods.include?(:module_namespacing)
        def module_namespacing
          yield if block_given?
        end
      end
    end
  end
end
