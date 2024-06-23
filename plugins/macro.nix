{pkgs, ...}:
with pkgs; {
  pkg = vimUtils.buildVimPlugin rec {
    name = "neocomposor";
    pname = "NeoComposer";
    version = "7636f9f447affe8bd26fee3b0c58fa19d78c62bb";
    src = fetchFromGitHub {
      owner = "hcssmith";
      repo = "NeoComposer.nvim";
      rev = version;
      hash = "sha256-S+2zycIKoIAAQnEyJJLhoe3KbOIl/HpkXus2nDA9OzQ";
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
