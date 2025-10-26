class Devinator
  class EditorConfiguration
    VALID_TIMINGS = [:end_of_setup, :first_command, :last_command]
    attr_accessor :command, :title
    attr_reader :timing

    def timing=(val)
      unless VALID_TIMINGS.include? val
        raise(
          ArgumentError,
          "must be one of #{VALID_TIMINGS.inspect}"
        )
      end

      @timing = val
    end
  end
end
