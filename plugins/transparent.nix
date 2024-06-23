{vimPlugins, ...}: {
  pkg = vimPlugins.transparent-nvim;
  name = "transparent";
  opts = {
    extra_groups = [
      "Normal"
      "NormalFloat"
      "NvimTreeNormal"
      "TabLine"
      "TabLineSel"
      "TabLineFill"
      "Folded"
      "RecordingSymbol"
    ];
  };
  extraConfig = ''
    require('transparent').clear_prefix('lualine')
    require('transparent').clear_prefix('neogit')
    require('transparent').clear_prefix('gitsigns')
    require('transparent').clear_prefix('noice')
  '';
}
