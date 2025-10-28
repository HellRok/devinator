require "tty-command"

require "devinator/config"
require "devinator/backends/tmux"

class Devinator
  def self.run
    tty = TTY::Command.new(uuid: false)

    user_config_path = File.expand_path("~/.config/devinator.rb")
    Kernel.require(user_config_path) if File.file?(user_config_path)

    Devinator::Config.setup_commands.each { tty.run it, only_output_on_error: true }

    tmux = Devinator::Backends::Tmux.new(
      name: File.basename(Dir.pwd),
      commands: Devinator::Config.run_commands,
      executer: tty
    )

    tmux.launch
  end
end
