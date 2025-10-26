describe Devinator::UserConfiguration do
  describe "#setup_commands" do
    it "returns an empty array if not specifically set" do
      expect(Devinator::UserConfiguration.new.setup_commands).to eq([])
    end

    it "returns an array if set to a single value" do
      config = Devinator::UserConfiguration.new

      config.setup_commands = "load_secrets"

      expect(config.setup_commands).to eq(["load_secrets"])
    end

    it "returns normally if already an array" do
      config = Devinator::UserConfiguration.new

      config.setup_commands = ["update_secrets", "load_secrets", "git pull"]

      expect(config.setup_commands).to eq(["update_secrets", "load_secrets", "git pull"])
    end
  end

  describe "#editor" do
    it "is a EditorConfiguration class" do
      config = Devinator::UserConfiguration.new

      expect(config.editor).to be_a(Devinator::EditorConfiguration)
    end
  end
end
