class Devinator
  class UserConfiguration
    attr_writer :setup_commands

    def initialize
      @setup_commands = []
    end

    def setup_commands
      if @setup_commands.is_a?(Enumerable)
        @setup_commands
      else
        [@setup_commands].compact
      end
    end
  end
end
