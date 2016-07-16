# install_generator.rb

module Bootstrapenhanced
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)
      desc "This generator installs Bootstrap Enhanced"
      argument :language_type, :type => :string, :default => 'de', :banner => '*de or other language'
      class_option :about_file, :type => :string
      class_option :contact_file, :type => :string

      # def run_other_generators
      #   generate "bootstrap:install"
      # end

      def adjust_application_html_file
        insert_into_file "app/views/layouts/application.html.erb", :before => "<%= yield %>\n" do
          "    <%= render 'layouts/menu' %>\n" +
          "    <div class=\"container\">\n" +
          "      <% flash.each do |name, msg| %>\n" +
          "        <%= content_tag(:div, msg, class: \"alert alert-info\") %>\n" +
          "      <% end %>\n" +
          "  "
        end
        insert_into_file "app/views/layouts/application.html.erb", :after => "<%= yield %>\n" do
          "    </div>\n"
        end
      end

      def insert_menu_bar_and_default_pages
        copy_file "_menu.html.erb", "app/views/layouts/_menu.html.erb"
        empty_directory "app/views/pages"
        if Dir.exist? "doc/pages"
          files = Dir.glob("doc/pages/*") - ['backup']
          FileUtils.cp_r files, "app/views/pages"
          puts "      Pages installed"
        else
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
        end
        copy_file "high_voltage.rb", "config/initializers/high_voltage.rb"
      end

      def switch_to_sass
        if FileTest.file? "app/assets/stylesheets/application.css"
          FileUtils.move "app/assets/stylesheets/application.css", "app/assets/stylesheets/application.scss"
        end
      end

      def adjust_application_scss
        gsub_file "app/assets/stylesheets/application.scss",
          " *= require_tree .\n *= require_self\n */\n",
          " */\n\n@import \"bootstrap\";\n"
      end

      def adjust_application_js
        insert_into_file "app/assets/javascripts/application.js", :after => "//= require jquery\n" do
          "//= require bootstrap\n"
        end
      end

      def add_menu_creation_on_model
        if FileTest.file? "lib/templates/erb/scaffold/_form.html.erb"
          insert_into_file "lib/templates/erb/scaffold/_form.html.erb",
            "# Menu\n",
            :before => "  create_file \"config/locales/de/de.model."
        end
      end

      def add_bootstrap_language_files
        if FileTest.file? "config/locales/en.bootstrap.yml"
          FileUtils.move "config/locales/en.bootstrap.yml", "config/locales/en/en.bootstrap.yml"
        end
        copy_file "de.bootstrap.yml", "config/locales/#{language_type}/#{language_type}.bootstrap.yml"
        copy_file "de.bootstrap-enhanced.yml", "config/locales/#{language_type}/#{language_type}.bootstrap-enhanced.yml"
      end

      # def change_table_class
      #   gsub_file "lib/templates/erb/scaffold/index.html.erb", "<table class=\"datatable display\">", "<table class=\"datatable display table table-striped table-bordered\">"
      # end

      def add_default_images
        if Dir.exist? "doc/images"
          files = Dir.glob("doc/images/*")
          FileUtils.cp_r files, "app/assets/images"
          puts "      Images installed"
        end
      end

      def add_default_stylesheets
        if Dir.exist? "doc/stylesheets"
          files = Dir.glob("doc/stylesheets/*") - ['backup']
          FileUtils.cp_r files, "app/assets/stylesheets"
          puts "      Stylesheets installed"
        end
      end

      def add_default_application_helper
        if File.exist? "doc/helpers/application_helper.rb"
          if File.exist? "app/helpers/application_helper.rb"
            FileUtils.remove "app/helpers/application_helper.rb"
          end
          files = Dir.glob("doc/helpers/*")
          FileUtils.cp_r files, "app/helpers"
          puts "      Helpers installed"
        end
      end

      def add_default_layouts
        if Dir.exist? "doc/layouts"
          files = Dir.glob("doc/layouts/*")
          FileUtils.cp_r files, "app/views/layouts"
          puts "      Layouts installed"
        end
      end

      def add_default_shared
        if Dir.exist? "doc/shared"
          empty_directory "app/views/shared"
          files = Dir.glob("doc/shared/*")
          FileUtils.cp_r files, "app/views/shared"
          puts "      Shared installed"
        end
      end

      def add_default_locales
        if Dir.exist? "doc/locales"
          files = Dir.glob("doc/locales/*")
          FileUtils.cp_r files, "config/locales/de"
          puts "      Locales installed"
        end
      end

    end
  end
end
