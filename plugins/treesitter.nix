{vimPlugins, ...}: {
  pkg = vimPlugins.nvim-treesitter;
  name = "nvim-treesitter.configs";
  deps = (
    map
    (v: {pkg = vimPlugins.nvim-treesitter.grammarToPlugin v;})
    vimPlugins.nvim-treesitter.allGrammars
  );
  opts = {
    highlight = {
      enable = true;
      disable = ["make"];
    };
    indent.enable = true;
    textobjects = {
      lsp_interop = {
        enable = true;
        peek_definition_code = {
          "<leader>dF" = {query = "@class.outer";};
          "<leader>df" = {query = "@function.outer";};
        };
      };
      select = {
        enable = true;
        lookahead = true;
        selection_modes = {
          "@funcion.inner" = "V";
          "@function.outer" = "V";
          "@parameter.inner" = "v";
        };
        keymaps = {
          "a=" = {query = "@assignment.outer";};
          "ab" = {query = "@block.outer";};
          "af" = {query = "@function.outer";};
          "i=" = {query = "@assignment.inner";};
          "ib" = {query = "@block.inner";};
          "if" = {query = "@function.inner";};
          "ip" = {query = "@parameter.inner";};
          "l=" = {query = "@assignment.lhs";};
          "r=" = {query = "@assignment.rhs";};
        };
      };
    };
  };
}
