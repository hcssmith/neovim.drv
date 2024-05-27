{
  vimPlugins,
  pkgs,
  ...
}: {
  pkg = vimPlugins.noice-nvim;
  name = "noice";
  deps = [
    {
      pkg = (
        pkgs.vimUtils.buildVimPlugin rec {
          name = "nui.nvim";
          version = "b1b3dcd6ed8f355c78bad3d395ff645be5f8b6ae";
          pname = "${name}-${version}";
          src = pkgs.fetchFromGitHub {
            owner = "MunifTanjim";
            repo = "nui.nvim";
            rev = "v${version}";
            hash = "sha256-JRVVRT1CZZTjr58L+gAer7eCg9/fMdAD0YD5ljNwl0Q=";
          };
        }
      );
    }
  ];
  opts = {
    lsp = {
      override = {
        "vim.lsp.util.convert_input_to_markdown_lines" = true;
        "vim.lsp.util.stylize_markdown" = true;
        "cmp.entry.get_documentation" = true;
      };
      hover.enabled = false;
      signature.enabled = false;
    };
    presets = {
      bottom_search = true;
      command_palette = true;
      long_message_to_split = true;
      inc_rename = false;
      lsp_doc_border = false;
    };
  };
}
