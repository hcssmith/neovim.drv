{
  description = "A very basic flake";

  inputs = {
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-lib.url = "github:hcssmith/flake-lib";
    application-builders.url = "github:hcssmith/application-builders";
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
      overlays = [
        self.overlays.default
        neovim-nightly-overlay.overlays.default
      ];
      drv = p: let
        vimPlugins = p.vimPlugins;
        pkgs = p;
      in
        application-builders.lib.mkNeovim {inherit pkgs;} {
          neovim = pkgs.neovim;
          extraPackages = with pkgs; [
            alejandra
            fd
            fswatch
            lua-language-server
            nixd
            nodePackages.bash-language-server
            ols
            ripgrep
            sqlite
            tree-sitter
          ];
          config = {
            colourscheme = "cyberdream";
            globals.mapleader = " ";
            opts = {
              backup = false;
              foldexpr = "nvim_treesitter#foldexpr()";
              foldmethod = "expr";
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
            lsp = {
              servers = [
                (import ./lsp/nixd.nix)
                (import ./lsp/bash.nix)
                (import ./lsp/odin.nix)
                (import ./lsp/lua.nix)
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
              {pkg = vimPlugins.vim-startuptime;}
              (import ./plugins/cmp.nix {inherit vimPlugins pkgs;})
              (import ./plugins/colourschemes.nix {inherit vimPlugins;})
              (import ./plugins/git_worktree.nix {inherit vimPlugins;})
              (import ./plugins/gitsigns.nix {inherit vimPlugins;})
              (import ./plugins/harpoon.nix {inherit vimPlugins;})
              (import ./plugins/lsp.nix {inherit vimPlugins;})
              (import ./plugins/lualine.nix {inherit vimPlugins;})
              (import ./plugins/luasnip.nix {inherit vimPlugins pkgs;})
              (import ./plugins/macro.nix {inherit pkgs;})
              (import ./plugins/neogit.nix {inherit pkgs;})
              (import ./plugins/noice.nix {inherit vimPlugins pkgs;})
              (import ./plugins/nvim-tree.nix {inherit vimPlugins;})
              (import ./plugins/telescope.nix {inherit vimPlugins pkgs;})
              (import ./plugins/treesitter.nix {inherit vimPlugins;})
            ];
            keymaps = nixpkgs.lib.flatten [
              (import ./keybind/movement.nix)
              (import ./keybind/qfutil.nix)
            ];
          };
        };
    };
}
