{
  vimPlugins,
  pkgs,
  ...
}: {
  pkg = (
    pkgs.vimUtils.buildVimPlugin rec {
      name = "nvim-cmp";
      version = "5260e5e8ecadaf13e6b82cf867a909f54e15fd07";
      pname = "${name}-${version}";
      src = pkgs.fetchFromGitHub {
        owner = "hrsh7th";
        repo = "nvim-cmp";
        rev = "v${version}";
        hash = "sha256-GhXfnWqpXFVM7Yi9+qEXHfA6LIMILcMG9pP4VYXuptE=";
      };
    }
  );
  deps = [
    {pkg = vimPlugins.cmp-buffer;}
    {pkg = vimPlugins.cmp-path;}
    {
      pkg = (
        pkgs.vimUtils.buildVimPlugin rec {
          name = "cmp-nvim-lsp";
          version = "39e2eda76828d88b773cc27a3f61d2ad782c922d";
          pname = "${name}-${version}";
          src = pkgs.fetchFromGitHub {
            owner = "hrsh7th";
            repo = "cmp-nvim-lsp";
            rev = "v${version}";
            hash = "sha256-CT1+Z4XJBVsl/RqvJeGmyitD6x7So0ylXvvef5jh7I8=";
          };
        }
      );
    }
    {pkg = vimPlugins.cmp-treesitter;}
    {pkg = vimPlugins.cmp_luasnip;}
  ];
  name = "cmp";
  extraConfigPre = "local cmp = require('cmp')";
  opts = {
    formatting = {
      fields = ["kind" "abbr" "menu"];
      format.__raw = ''
        function(entry, vim_item)
        	local kind = require("lspkind").cmp_format({ mode = "symbol", maxwidth = 50 })(entry, vim_item).kind or " "
        		vim_item.kind = " " .. kind .. " "
        		vim_item.menu = ({
        			nvim_lsp = "[Lsp]",
                  path = "[Path]",
                  buffer = "[Buf]",
                  luasnip = "[Snip]",
                  treesitter = "[Tree]",
                })[entry.source.name]
              return vim_item
            end
      '';
    };
    mapping = {
      "<C-Space>".__raw = "cmp.mapping.complete()";
      "<C-b>".__raw = "cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' })";
      "<C-f>".__raw = "cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' })";
      "<CR>".__raw = "cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })";
      "<Down>".__raw = "cmp.mapping.select_next_item()";
      "<Up>".__raw = "cmp.mapping.select_prev_item()";
    };
    snippet.expand.__raw = ''
      function(args)
           require'luasnip'.lsp_expand(args.body)
         end
    '';
    sources = [
      {name = "nvim_lsp";}
      {name = "path";}
      {name = "luasnip";}
      {name = "buffer";}
      {name = "treesitter";}
    ];

    window = {
      completion = {
        border = "none";
        col_offset = -4;
        side_padding = 1;
        winhighlight = "Normal:CmpNormal,CmpItemAbbr:CmpNormal,Search:None";
      };
    };
  };
}
