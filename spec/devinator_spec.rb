describe Devinator do
  describe ".run" do
    before do
      @tty = double(:tty)
      allow(TTY::Command).to receive(:new).and_return(@tty)
    end

    it "creates a TTY::Command object" do
      expect(TTY::Command).to receive(:new).with(uuid: false)

      Devinator.run
    end

    it "runs the setup commands before run commands" do
      File.write "bin/setup", ""
      File.write "bin/dev", ""

      expect(@tty).to receive(:run).with(
        "bin/setup",
        only_output_on_error: true
      )

      pending "implement multiplexer"
      expect(@tty).to receive(:run).with(
        "bin/dev",
        only_output_on_error: true
      ).ordered

      Devinator.run
    end
  end
end
