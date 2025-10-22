# Devinator

A simple tool to help start your development environment. It's fairly
opinionated but can be twisted to your will.

## How it works

Simply `cd` to your project and run `devinator`. It will do several things for
you in this order:

1. `dx/build`
2. `dx/start`
3. `bin/setup` or `bin/setup`
4. start your multiplexer
5. launch your editor
6. run the commands in `Procfile.dev` or `bin/dev`
