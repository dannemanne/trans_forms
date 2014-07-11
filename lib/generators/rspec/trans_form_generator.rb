module Rspec
  class TransFormGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_spec_file
      template 'trans_form_spec.rb', File.join('spec/trans_forms', class_path, "#{file_name}_spec.rb")
    end
  end
end
