require "tty-command"

require "devinator/config"
require "devinator/backends/tmux"

class Devinator
  def self.run
    tty = TTY::Command.new(uuid: false)

    Config.setup_commands.each { tty.run it, only_output_on_error: true }

    tmux = Devinator::Backends::Tmux.new(
      name: File.basename(Dir.pwd),
      commands: Config.run_commands,
      executer: tty
    )

    tmux.launch
  end
end
