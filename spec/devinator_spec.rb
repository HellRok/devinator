describe Devinator do
  describe ".run" do
    before do
      @tty = double(:tty)
      @tmux = double(:tmux)
      allow(TTY::Command).to receive(:new).and_return(@tty)
    end

    it "runs the setup commands before run commands" do
      expect(TTY::Command).to receive(:new).with(uuid: false)

      expect(Dir).to receive(:pwd).and_return("/path/to/project")
      File.write "bin/setup", ""
      File.write "bin/dev", ""

      expect(@tty).to receive(:run).with(
        "bin/setup",
        only_output_on_error: true
      )

      expect(Devinator::Backends::Tmux).to receive(:new).with(
        name: "project",
        commands: [
          title: "dev", command: "bin/dev"
        ],
        executer: @tty
      ).and_return(@tmux).ordered

      expect(@tmux).to receive(:launch)

      Devinator.run
    end
  end
end
