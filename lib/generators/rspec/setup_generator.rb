module Rspec
  class SetupGenerator < ::Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def create_spec_file
      template 'application_trans_form_spec.rb', File.join('spec/trans_forms', 'application_trans_form_spec.rb')
    end
  end
end
