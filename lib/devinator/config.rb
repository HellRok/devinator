require "devinator/editor_configuration"
require "devinator/user_configuration"

class Devinator
  class Config
    @setup_commands = []
    @commands = []

    def self.user_configuration
      @user_configuration ||= Devinator::UserConfiguration.new
    end

    def self.configure
      yield user_configuration
    end

    def self.setup_commands
      @setup_commands = []

      @setup_commands += user_configuration.setup_commands

      @setup_commands << "dx/build" if File.file? "dx/build"
      @setup_commands << "dx/start" if File.file? "dx/start"

      @setup_commands << dx_exec("bin/setup") if File.file? "bin/setup"

      @setup_commands << user_configuration.editor.command if user_configuration.editor.timing == :end_of_setup

      @setup_commands
    end

    def self.run_commands
      @commands = []

      if user_configuration.editor.timing == :first_command
        @commands << {
          title: user_configuration.editor.title,
          command: user_configuration.editor.command
        }
      end

      if File.file? "Procfile.dev"
        File.read("Procfile.dev").lines.each { |line|
          name, command = line.split(":", 2)
          @commands << {title: name, command: dx_exec(command.strip)}
        }

      elsif File.file? "bin/dev"
        @commands << {title: "dev", command: dx_exec("bin/dev")}
      end

      if user_configuration.editor.timing == :last_command
        @commands << {
          title: user_configuration.editor.title,
          command: user_configuration.editor.command
        }
      end

      @commands
    end

    private_class_method def self.dx_exec(command)
      result = ""
      result << "dx/exec " if File.file? "dx/exec"
      result << command
    end
  end
end
