{
  vimPlugins,
  pkgs,
  lib,
  ...
}: let
  my_snippets = {
    paths = ../snippets;
  };
in {
  pkg = vimPlugins.luasnip;
  name = "luasnip";
  deps = [
    {pkg = vimPlugins.friendly-snippets;}
  ];
  opts = {
    history = true;
    updateevents = "TextChanged,TextChangedI";
  };
  extraConfig = ''
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").load(${lib.lua-utils.toLuaObject my_snippets})
  '';
  keymaps = [
    {
      action = ''
        function()
          local ls = require('luasnip')
          if ls.jumpable(1) then
            ls.jump(1)
          end
        end
      '';
      key = "<C-j>";
      mode = ["i" "s"];
    }
    {
      action = ''
        function()
          local ls = require('luasnip')
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end
      '';
      key = "<C-k>";
      mode = ["i" "s"];
    }
    {
      action = ''
        function()
          local ls = require('luasnip')
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end
      '';
      key = "<C-c>";
      mode = ["i" "s"];
    }
  ];
}
