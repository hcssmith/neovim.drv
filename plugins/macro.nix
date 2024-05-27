{pkgs, ...}:
with pkgs; {
  pkg = vimUtils.buildVimPlugin rec {
    name = "neocomposor";
    pname = "NeoComposer";
    version = "b06e8e88e289947937f241f76e86f7c46f4a5805";
    src = fetchFromGitHub {
      owner = "ecthelionvi";
      repo = "NeoComposer.nvim";
      rev = version;
      hash = "sha256-AQU+Z7iC7AMm17k7gw7dA0TEmImpJJhZ2rPk8zReJFg=";
    };
  };
  extraConfig = "require('telescope').load_extension('macros')";
  extraConfigVim = ''
    let g:sqlite_clib_path = '${sqlite.out}/lib/libsqlite3.so'
  '';
  name = "NeoComposer";
  deps = [
    {pkg = vimPlugins.sqlite-lua;}
  ];
  keymaps = [
    {
      action = ''
        function() require('NeoComposer.telescope.macros').show_macros() end
      '';
      key = "<leader>m";
    }
  ];
}
