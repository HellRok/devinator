class Devinator
  module Backends
    class Tmux
      BINARY = "tmux"

      def initialize(name:, commands:, executer:)
        @name = name
        @commands = commands
        @executer = executer
      end

      def launch
        if session?
          reconnect
        else
          run_commands
          connect
        end
      end

      def session?
        @executer.run!(BINARY, "has-session", "-t", @name).success?
      end

      def reconnect
        Process.exec(BINARY, "attach-session", "-t", @name)
      end

      def connect
        @executer.run(
          BINARY, "select-window", "-t", "#{@name}:0",
          only_output_on_error: true
        )
        Process.exec(BINARY, "attach-session", "-t", @name)
      end

      def run_commands
        @executer.run(
          BINARY, "new-session", "-d", "-s", @name,
          only_output_on_error: true
        )

        @commands.each_with_index do |command, index|
          if index.zero?
            @executer.run(
              BINARY, "rename-window", "-t", @name, command[:title],
              only_output_on_error: true
            )
          else
            @executer.run(
              BINARY, "new-window", "-t", @name, "-n", command[:title],
              only_output_on_error: true
            )
          end

          @executer.run(
            BINARY, "send-keys", "-t", @name, command[:command], "C-m",
            only_output_on_error: true
          )
        end
      end
    end
  end
end
