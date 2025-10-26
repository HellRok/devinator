describe Devinator::UserConfiguration do
  describe "#timing=" do
    it "lets you set :end_of_setup, :first_command, and :last_command" do
      config = Devinator::EditorConfiguration.new

      expect do
        config.timing = :end_of_setup
        config.timing = :first_command
        config.timing = :last_command
      end.not_to raise_error
    end

    it "raises an error if passed a different value" do
      config = Devinator::EditorConfiguration.new

      expect do
        config.timing = :nope
      end.to raise_error(
        ArgumentError,
        "must be one of [:end_of_setup, :first_command, :last_command]"
      )
    end
  end
end
