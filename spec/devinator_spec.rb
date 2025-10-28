describe Devinator do
  describe ".run" do
    before do
      @tty = double(:tty)
      allow(TTY::Command).to receive(:new).and_return(@tty)

      allow(Dir).to receive(:pwd).and_return("/path/to/project")
      allow(Devinator::Config).to receive(:setup_commands).and_return([])
      allow(Devinator::Config).to receive(:run_commands).and_return([])

      @tmux = double(:tmux)
      allow(Devinator::Backends::Tmux).to receive(:new).and_return(@tmux)
      allow(@tmux).to receive(:launch)
    end

    it "runs the setup commands before run commands" do
      expect(File).to receive(:expand_path).with("~/.config/devinator.rb").and_return("user config")
      expect(File).to receive(:file?).with("user config").and_return(false)
      expect(TTY::Command).to receive(:new).with(uuid: false)

      expect(Dir).to receive(:pwd).and_return("/path/to/project")
      expect(Devinator::Config).to receive(:setup_commands).and_return(["bin/setup"])

      expect(@tty).to receive(:run).with(
        "bin/setup",
        only_output_on_error: true
      )

      allow(Devinator::Config).to receive(:run_commands).and_return(
        [{title: "dev", command: "bin/dev"}]
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

    it "loads the user config" do
      expect(File).to receive(:expand_path).with("~/.config/devinator.rb").and_return("user config")
      expect(File).to receive(:file?).with("user config").and_return(true)

      expect(Kernel).to receive(:require).with("user config")

      Devinator.run
    end
  end
end
