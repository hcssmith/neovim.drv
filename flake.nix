{
  description = "My neovim derivation.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    #nixpkgs.url = "git+file:///home/hcssmith/Projects/nixpkgs";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-lib = {
      url = "github:hcssmith/flake-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    application-builders = {
      url = "github:hcssmith/application-builders";
      #url = "git+file:///home/hcssmith/Projects/application-builders";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    neovim-nightly-overlay,
    flake-lib,
    application-builders,
    ...
  }:
    flake-lib.lib.mkApp {
      inherit self;
      name = "neovim";
      drv = p: let
        vimPlugins = p.vimPlugins;
      in
        application-builders.lib.mkNeovim rec {
          pkgs = p;
          neovim = neovim-nightly-overlay.packages.${p.system}.neovim;
          extraPackages = with pkgs; [
            alejandra
            sqlite
          ];
          config = {
            colourscheme = "ayu-mirage";
            globals.mapleader = " ";
            opts = {
              backup = false;
              foldexpr = "nvim_treesitter#foldexpr()";
              foldmethod = "expr";
              foldlevel = 99;
              number = true;
              relativenumber = true;
              scrolloff = 8;
              shiftwidth = 2;
              signcolumn = "yes";
              swapfile = false;
              tabstop = 2;
              termguicolors = true;
              wrap = false;
            };
            treesitter.extra_grammars = import ./tree-sitter/grammars.nix {
              inherit pkgs;
              inherit (pkgs.tree-sitter) buildGrammar;
            };
            lsp = {
              servers = [
                (import ./lsp/nixd.nix {inherit pkgs;})
                (import ./lsp/bash.nix {inherit pkgs;})
                (import ./lsp/odin.nix {inherit pkgs;})
                (import ./lsp/lua.nix {inherit pkgs;})
              ];
            };
            autogroups = [
              "UserUtil"
              "UserLsp"
            ];
            autocmds = nixpkgs.lib.flatten [
              (import ./autocmds/lsp.nix)
              (import ./autocmds/utils.nix)
            ];
            plugins = nixpkgs.lib.flatten [
              {pkg = vimPlugins.vim-tmux-navigator;}
              {
                pkg = vimPlugins.nvim-nu;
                name = "nu";
              }
              (import ./plugins/cmp.nix {inherit vimPlugins pkgs;})
              (import ./plugins/colourschemes.nix {inherit vimPlugins;})
              (import ./plugins/git_worktree.nix {inherit vimPlugins;})
              (import ./plugins/gitsigns.nix {inherit vimPlugins;})
              (import ./plugins/harpoon.nix {inherit vimPlugins;})
              (import ./plugins/lualine.nix {inherit vimPlugins;})
              (import ./plugins/luasnip.nix {
                inherit vimPlugins pkgs;
                lib = application-builders.lib;
              })
              (import ./plugins/macro.nix {inherit pkgs;})
              (import ./plugins/neogit.nix {inherit pkgs;})
              (import ./plugins/noice.nix {inherit vimPlugins pkgs;})
              (import ./plugins/nvim-tree.nix {inherit vimPlugins;})
              (import ./plugins/telescope.nix {inherit vimPlugins pkgs;})
              (import ./plugins/transparent.nix {inherit vimPlugins;})
            ];
            keymaps = nixpkgs.lib.flatten [
              (import ./keybind/movement.nix)
              (import ./keybind/qfutil.nix)
            ];
          };
        };
    };
}
