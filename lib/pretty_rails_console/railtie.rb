require "pry-rails"
require "awesome_print"

module PrettyRailsConsole
  class Railtie < Rails::Railtie
    initializer "pretty_rails_console.initialize" do |app|
      disables_pry_plugin_loading
      use_awesome_print_for_formatting
      set_prompt_name_to_project_name
      show_rails_env_name_before_prompt
    end

    private

    def disables_pry_plugin_loading
      Pry.config.should_load_plugins = false
    end

    def use_awesome_print_for_formatting
      AwesomePrint.pry!
    end

    def set_prompt_name_to_project_name
      # ref from https://github.com/rweng/pry-rails/blob/035d5c8203521f5eaac0001300152281c765df88/lib/pry-rails/prompt.rb
      Pry.config.prompt_name =
        if Rails::VERSION::MAJOR >= 6
          Rails.application.class.module_parent_name.underscore
        else
          Rails.application.class.parent_name.underscore
        end
    end

    def show_rails_env_name_before_prompt
      old_prompt = Pry::Prompt[:default]

      Pry.config.prompt = Pry::Prompt.new(
        "pretty",
        "pretty rails console",
        [
          proc { |*a| "#{Rails.env.classify} #{old_prompt.wait_proc.call(*a)}"  },
          proc { |*a| "#{Rails.env.classify} #{old_prompt.incomplete_proc.call(*a)}" },
        ],
      )
    end
  end
end
