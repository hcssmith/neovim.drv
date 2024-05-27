{vimPlugins, ...}: {
  pkg = vimPlugins.lualine-nvim;
  name = "lualine";
  opts = {
    options = {
      globalstatus = true;
      icons_enabled = true;
    };
    sections = {
      lualine_a = [
        ["require('NeoComposer.ui').status_recording()"]
        ["mode"]
      ];
      lualine_c = [
        ["filename"]
        ["require('lspsaga.symbol.winbar').get_bar()"]
      ];
    };
  };
}
