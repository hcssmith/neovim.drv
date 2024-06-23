{pkgs, ...}:
with pkgs; {
  pkg = vimUtils.buildVimPlugin rec {
    name = "neocomposor";
    pname = "NeoComposer";
    version = "7ecb04d4a1712a6fd7272c1c9482ea878c144588";
    src = fetchFromGitHub {
      owner = "ecthelionvi";
      repo = "NeoComposer.nvim";
      rev = version;
      hash = "sha256-S+2zycIKoIAAQnEyJJLhoe3KbOIl/HpkXus2nDA9OzQ=";
    };
  };
  extraConfig = "require('telescope').load_extension('macros')";
  extraConfigVim = ''
    let g:sqlite_clib_path = '${sqlite.out}/lib/libsqlite3.so'
  '';
  name = "NeoComposer";
  opts = {
    queue_most_recent = true;
  };
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
