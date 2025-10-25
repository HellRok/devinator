class Devinator
  class Config
    def self.setup_commands
      commands = []

      commands << "dx/build" if File.exist? "dx/build"
      commands << "dx/start" if File.exist? "dx/start"

      commands << dx_exec("bin/setup") if File.exist? "bin/setup"

      commands
    end

    def self.run_commands
      commands = []

      if File.exist? "Procfile.dev"
        File.read("Procfile.dev").lines.each { |line|
          name, command = line.split(":", 2)
          commands << {title: name, command: dx_exec(command.strip)}
        }

      elsif File.exist? "bin/dev"
        commands << {title: "dev", command: dx_exec("bin/dev")}
      end

      commands
    end

    private_class_method def self.dx_exec(command)
      result = ""
      result << "dx/exec " if File.exist? "dx/exec"
      result << command
    end
  end
end
