require_relative "lib/devinator/version"

Gem::Specification.new do |gem|
  gem.name = "devinator"
  gem.version = Devinator::VERSION
  gem.summary = "Start your development environment with one command!"
  gem.description = <<-DESC
    A little tool to help you get your development
    environment up and running with a single command.
  DESC
  gem.authors = ["Sean Earle"]
  gem.email = ["sean.r.earle@gmail.com"]
  gem.homepage = "https://github.com/HellRok/devinator"
  gem.license = "MIT"
  gem.required_ruby_version = ">= 2.6.0"

  gem.files = `git ls-files`.split($\)
  gem.executables = [
    "devinator"
  ]

  gem.add_dependency "tty-command"
end
