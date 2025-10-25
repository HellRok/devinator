describe Devinator::Backends::Tmux do
  before do
    @tmux = Devinator::Backends::Tmux
  end

  describe "#session?" do
    before do
      @tty = double(:tty)
    end

    it "returns true if there is a session" do
      expect(@tty).to receive(:run!).with(
        "tmux", "has-session", "-t", "the-session"
      ).and_return(double(:result, success?: true))

      expect(
        @tmux.new(
          name: "the-session",
          commands: [],
          executer: @tty
        ).session?
      ).to be(true)
    end

    it "returns false if there is no session" do
      expect(@tty).to receive(:run!).with(
        "tmux", "has-session", "-t", "the-session"
      ).and_return(double(:result, success?: false))

      expect(
        @tmux.new(
          name: "the-session",
          commands: [],
          executer: @tty
        ).session?
      ).to be(false)
    end

    describe "#reconnect" do
      it "reconnects to the session" do
        expect(@tty).to receive(:run).with(
          "tmux", "attach-session", "-t", "the-session",
          only_output_on_error: true
        )

        @tmux.new(
          name: "the-session",
          commands: [],
          executer: @tty
        ).reconnect
      end
    end

    describe "#run_commands" do
      it "launches a session on the first command then a new window for each following command" do
        expect(@tty).to receive(:run).with(
          "tmux", "new-session", "-d", "-s", "the-session", "-n", "cmd1",
          only_output_on_error: true
        )

        expect(@tty).to receive(:run).with(
          "tmux", "send-keys", "-t", "the-session", "command 1", "C-m",
          only_output_on_error: true
        )

        expect(@tty).to receive(:run).with(
          "tmux", "new-window", "-t", "the-session", "-n", "cmd2",
          only_output_on_error: true
        )

        expect(@tty).to receive(:run).with(
          "tmux", "send-keys", "-t", "the-session", "command 2", "C-m",
          only_output_on_error: true
        )

        expect(@tty).to receive(:run).with(
          "tmux", "new-window", "-t", "the-session", "-n", "cmd3",
          only_output_on_error: true
        )

        expect(@tty).to receive(:run).with(
          "tmux", "send-keys", "-t", "the-session", "command 3", "C-m",
          only_output_on_error: true
        )

        @tmux.new(
          name: "the-session",
          commands: [
            {title: "cmd1", command: "command 1"},
            {title: "cmd2", command: "command 2"},
            {title: "cmd3", command: "command 3"}
          ],
          executer: @tty
        ).run_commands
      end
    end

    describe "#connect" do
      it "connects to the tmux session" do
        expect(@tty).to receive(:run).with(
          "tmux", "select-window", "-t", "the-session:0",
          only_output_on_error: true
        )

        @tmux.new(
          name: "the-session",
          commands: [],
          executer: @tty
        ).connect
      end
    end
  end
end
