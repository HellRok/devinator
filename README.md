# Devinator

A simple tool to help start your development environment. It's fairly
opinionated but can be twisted to your will.

## How it works

Simply `cd` to your project and run `devinator`. It will do several things for
you in this order:

1. `bin/setup`
2. launch your editor
3. start `tmux`
4. run the commands in `Procfile.dev` or `bin/dev`

### With a dx setup

If you have some extra files they will be used to run your project in the dx
environment. So running it would look more like:

1. `dx/build`
2. `dx/start`
3. `dx/exec bin/setup`
5. launch your editor
4. start `tmux`
6. run the commands in `Procfile.dev` prefixed with `dx/exec` or `dx/exec bin/dev`

## Installation for Linux/OSX

1. run `ruby --version` to confirm it's installed
2. `gem install devinator`
3. `which devinator` to confirm it installed and is in your `$PATH`

## Configuration

Open `~/.config/devinator.rb` with your editor of choice and add the following
content:

```ruby
Devinator::Config.configure do |config|
  # Use this to run any personal commands before the usual culprits, this is
  # useful for loading secrets and the like.
  config.setup_commands = []

  # If your editor is run in as :first_command or :last_command then this is the
  # title that tmux will get for that window.
  config.editor.title = "editor"

  # This is your editor command, if you're running it with a timing of
  # :end_of_setup then you will want to make sure this isn't foregrounded. I
  # belive `code` by default will go into the background, so that's a good setup
  # if you use VSCode.
  config.editor.command = ENV["EDITOR"]

  # This is when you want your editor command to run, the valid options are:
  #   - :end_of_setup
  #   - :first_command
  #   - :last_command
  #
  # :end_of_setup will call it as the last setup command before tmux is
  # launched.
  # :first_command will call it in the first window of tmux
  # :last_command will call it in the last window of tmux
  config.editor.timing = :first_command
end
```
