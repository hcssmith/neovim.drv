{
  vimPlugins,
  pkgs,
}: {
  pkg = (
    pkgs.vimUtils.buildVimPlugin rec {
      name = "telescope.nvim";
      version = "4c96370cf93e2ba287548da12d673442d0ffecc3";
      pname = "${name}-${version}";
      src = pkgs.fetchFromGitHub {
        owner = "nvim-telescope";
        repo = "telescope.nvim";
        rev = "v${version}";
        hash = "sha256-YCAOZzC99NdAC5HsJa2N1RKI+OAbYxvj1hCTydN0muA=";
      };
    }
  );
  name = "telescope";
  deps = [
    {pkg = vimPlugins.plenary-nvim;}
  ];
  keymaps = [
    {
      key = "<leader>ff";
      action = "function() require('telescope.builtin').find_files() end";
    }
    {
      key = "<leader>fb";
      action = "function() require('telescope.builtin').buffers() end";
    }
    {
      key = "<leader>gf";
      action = "function() require('telescope.builtin').git_files() end";
    }
    {
      key = "<leader>vh";
      action = "function() require('telescope.builtin').help_tags() end";
    }
    {
      key = "<leader>ps";
      action = "function() require('telescope.builtin').grep_string({search = vim.fn.input('Grep > ')}) end";
    }
  ];
}
