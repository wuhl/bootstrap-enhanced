# install_generator.rb

module Bootstrapenhanced
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)
      desc "This generator installs Bootstrap Enhanced"
      argument :language_type, :type => :string, :default => 'de', :banner => '*de or other language'
      class_option :about_file, :type => :string
      class_option :contact_file, :type => :string

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
      end

      def insert_menu_bar_and_default_pages
        copy_file "_menu.html.erb", "app/views/layouts/_menu.html.erb"
        empty_directory "app/views/pages"
        
        about_file = "pages/about.html.erb"
        if options[:about_file]
          about_file = options[:about_file]
        end
        copy_file about_file, "app/views/pages/about.html.erb"
        
        contact_file = "pages/contact.html.erb"
        if options[:contact_file]
          contact_file = options[:contact_file]
        end
        copy_file contact_file, "app/views/pages/contact.html.erb"
        
        copy_file "high_voltage.rb", "config/initializers/high_voltage.rb"
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