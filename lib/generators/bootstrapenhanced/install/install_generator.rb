# install_generator.rb

module Bootstrapenhanced
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)
      desc "This generator installs Bootstrap Enhanced"
      argument :language_type, :type => :string, :default => 'de', :banner => '*de or other language'

      def run_other_generators
        generate "bootstrap:install"
      end

      def adjust_application_html_file  
        insert_into_file "app/views/layouts/application.html.erb", :after => "<body>\n\n" do
          "  <%= render 'layouts/menu' %>\n" +
          "  <div class=\"container\">\n" +
          "    "
        end
        insert_into_file "app/views/layouts/application.html.erb", :after => "<%= yield %>\n" do
          "  </div>\n"
        end
        copy_file "_menu.html.erb", "app/views/layouts/_menu.html.erb"
      end

      def adjust_menu_place
        insert_into_file "app/assets/stylesheets/bootstrap_and_overrides.css.less", :after => "@import \"twitter/bootstrap/bootstrap\";\n" do
          "\n" +
          "body { padding-top: 60px; }\n" +
          "\n"
        end
      end

      def add_bootstrap_language_files
        if FileTest.file? "config/locales/en.bootstrap.yml"
          FileUtils.move "config/locales/en.bootstrap.yml", "config/locales/en/en.bootstrap.yml"
        end
        copy_file "de.bootstrap.yml", "config/locales/#{language_type}/#{language_type}.bootstrap.yml"
        copy_file "de.bootstrap-enhanced.yml", "config/locales/#{language_type}/#{language_type}.bootstrap-enhanced.yml"
      end

    end
  end
end