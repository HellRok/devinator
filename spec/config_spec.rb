describe Devinator::Config do
  describe ".setup_commands" do
    it "returns nothing when no files" do
      expect(Devinator::Config.setup_commands).to eq([])
    end

    it "returns bin/setup when available" do
      File.write "bin/setup", ""

      expect(Devinator::Config.setup_commands).to eq(["bin/setup"])
    end

    it "returns dx/exec bin/setup when both are available" do
      File.write "dx/exec", ""
      File.write "bin/setup", ""

      expect(Devinator::Config.setup_commands).to eq(["dx/exec bin/setup"])
    end

    it "returns dx/start when available" do
      File.write "dx/start", ""

      expect(Devinator::Config.setup_commands).to eq(["dx/start"])
    end

    it "returns dx/build when available" do
      File.write "dx/build", ""

      expect(Devinator::Config.setup_commands).to eq(["dx/build"])
    end

    it "returns all files when available" do
      File.write "bin/setup", ""
      File.write "dx/start", ""
      File.write "dx/build", ""

      expect(Devinator::Config.setup_commands).to eq(
        [
          "dx/build",
          "dx/start",
          "bin/setup"
        ]
      )
    end
  end

  describe ".run_commands" do
    context "with a bin/dev" do
      it "returns nothing when no files" do
        expect(Devinator::Config.run_commands).to eq([])
      end

      it "returns bin/dev when available" do
        File.write "bin/dev", ""

        expect(Devinator::Config.run_commands).to eq([
          {title: "dev", command: "bin/dev"}
        ])
      end

      it "returns dx/exec bin/dev when both available" do
        File.write "dx/exec", ""
        File.write "bin/dev", ""

        expect(Devinator::Config.run_commands).to eq([
          {title: "dev", command: "dx/exec bin/dev"}
        ])
      end
    end

    context "with a Procfile.dev" do
      it "returns nothing when no files" do
        expect(Devinator::Config.run_commands).to eq([])
      end

      it "uses Procfile.dev commands" do
        File.write "Procfile.dev", <<~PROCFILE
          web: bin/web
          assets: bin/assets
        PROCFILE

        expect(Devinator::Config.run_commands).to eq([
          {title: "web", command: "bin/web"},
          {title: "assets", command: "bin/assets"}
        ])
      end

      it "returns dx/exec for the commands when present" do
        File.write "dx/exec", ""
        File.write "Procfile.dev", <<~PROCFILE
          web: bin/web
          assets: bin/assets
        PROCFILE

        expect(Devinator::Config.run_commands).to eq([
          {title: "web", command: "dx/exec bin/web"},
          {title: "assets", command: "dx/exec bin/assets"}
        ])
      end

      context "when bin/dev is also present" do
        it "uses Procfile.dev commands and ignores bin/dev" do
          File.write "bin/dev", ""
          File.write "Procfile.dev", <<~PROCFILE
            web: bin/web
            tests: bin/tests
          PROCFILE

          expect(Devinator::Config.run_commands).to eq([
            {title: "web", command: "bin/web"},
            {title: "tests", command: "bin/tests"}
          ])
        end
      end
    end
  end
end
