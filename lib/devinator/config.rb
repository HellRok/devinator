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

      @setup_commands << "dx/build" if File.exist? "dx/build"
      @setup_commands << "dx/start" if File.exist? "dx/start"

      @setup_commands << dx_exec("bin/setup") if File.exist? "bin/setup"

      @setup_commands
    end

    def self.run_commands
      @commands = []

      if File.exist? "Procfile.dev"
        File.read("Procfile.dev").lines.each { |line|
          name, command = line.split(":", 2)
          @commands << {title: name, command: dx_exec(command.strip)}
        }

      elsif File.exist? "bin/dev"
        @commands << {title: "dev", command: dx_exec("bin/dev")}
      end

      @commands
    end

    private_class_method def self.dx_exec(command)
      result = ""
      result << "dx/exec " if File.exist? "dx/exec"
      result << command
    end
  end
end
