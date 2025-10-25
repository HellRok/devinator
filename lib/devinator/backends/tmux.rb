class Devinator
  module Backends
    class Tmux
      BINARY = "tmux"

      def initialize(name:, commands:, executer:)
        @name = name
        @commands = commands
        @executer = executer
      end

      def session?
        @executer.run!(BINARY, "has-session", "-t", @name).success?
      end

      def reconnect
        @executer.run(
          BINARY, "attach-session", "-t", @name,
          only_output_on_error: true
        )
      end

      def connect
        @executer.run(
          BINARY, "select-window", "-t", "#{@name}:0",
          only_output_on_error: true
        )
      end

      def run_commands
        @commands.each_with_index do |command, index|
          if index.zero?
            @executer.run(
              BINARY, "new-session", "-d", "-s", @name, "-n", command[:title],
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
