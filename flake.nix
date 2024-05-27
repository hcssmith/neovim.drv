{
  description = "A very basic flake";

  inputs = {
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    neovim-nightly-overlay,
    ...
  }: let
    supportedSystems = [
      "x86_64-linux"
    ];

    overlays = [
      neovim-nightly-overlay.overlays.default
      self.overlays.default
    ];
    lib = import ./lib {inherit nixpkgs supportedSystems overlays;};
    inherit (lib) forAllSystems nixpkgsFor mkNeovimWrap;
  in {
    formatter = forAllSystems (system: nixpkgsFor.${system}.alejandra);
    overlays.default = final: prev: {
      test = prev.writeShellScriptBin "test" ''
        echo test
      '';
      neovim = let
        pkgs = prev;
        vimPlugins = pkgs.vimPlugins;
      in
        mkNeovimWrap {
          nixpkgs = pkgs;
          neovim = pkgs.neovim;
          extraPackages = with pkgs; [
            alejandra
            fd
            fswatch
            nixd
            ripgrep
            sqlite
            tree-sitter
          ];
          config = {
            colourscheme = "retrobox";
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
                {
                  server_name = "nixd";
                  settings = {
                    formatting.command = ["alejandra"];
                  };
                }
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
              (import ./plugins/cmp.nix {inherit vimPlugins pkgs;})
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
    packages = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      test = pkgs.test;
      neovim = pkgs.neovim;
    });
  };
}
