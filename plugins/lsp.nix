{vimPlugins, ...}: [
  {pkg = vimPlugins.nvim-lspconfig;}
  {
    pkg = vimPlugins.lspsaga-nvim;
    name = "lspsaga";
    opts = {
      symbol_in_winbar.enable = false;
    };
  }
  {pkg = vimPlugins.lsp_signature-nvim;}
  {pkg = vimPlugins.lspkind-nvim;}
]
