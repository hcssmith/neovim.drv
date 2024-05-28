# Neovim.drv

My neovim derivation transformed into a nix flake with no external configuration
dependancies. I have used the builtin package manager to load all plugins into
the `/pack/*/start/{name}` dir. As part of the plugin management process, I
merge the individual configuration into the plugin under a `name-version` file
in the plugin dir to ensure it is auto-loaded, this keeps the `init.lua` file to
a minimum size, with just general configuration, rather than plugin specific
configuration.

## TODO
- Using telescope create a function to show optional plugins and load from a list.
- Setup additional LSP servers.
- Setup github CI to build app-image on major release tags.

## Usage
In order to use this flake you can either run `nix run
github:hcssmith/neovim.drv` or the flake provides a neovim override on
`FLAKE.overlays.default` which can be included in a nixos or home-manager
configuration.

## Overrides
I have overridden the following packages to account for neovim-0.11's
depcrications:

- NeoComposor
- telescope
- nvim-cmp
- cmp-nvim-lsp
- neogit
- nui.nvim

The should be checked regularly to see if nixos-unstable now has the correct
version so the override can be removed.

## plugin spec
- pkg: Plugin derivation.
- name: name to be passed to the require call in the setup stage. If missing no
  setup call is made.
- opts: table to be passed to the setup call.
- deps: list of plugin specs to also be included.
- optional: put into opt directory if true.
- extraConfigPre: put before setup call (lua).
- extraConfig: after setup call (lua).
- extraConfigVim: after setup call (vim).
- keymaps: list of keymaps to add.

## keymap spec
- action: lua function or vim command.
- key: keys to trigger
- opts: options to pass to keymap function.
- mode: which mode to map the action to.
- lua: whether to treat the action as a lua function or not.
