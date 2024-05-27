{
  nixpkgs,
  neovim,
  extraPackages ? [],
  config ? {},
  ...
}: let
  pkgs = nixpkgs;
  lib = pkgs.lib;
  neovim-utils = import ./neovim-utils.nix {inherit nixpkgs;};

  makeKeymap = keymaps: (builtins.concatStringsSep "\n" (map (
      {
        action,
        key,
        opts ? {},
        mode ? ["n"],
        lua ? true,
      }:
        if lua
        then "vim.keymap.set(${neovim-utils.toLuaObject mode}, '${key}', ${action}, ${neovim-utils.toLuaObject opts})"
        else "vim.keymap.set(${neovim-utils.toLuaObject mode}, '${key}', [[${action}]], ${neovim-utils.toLuaObject opts})"
    )
    keymaps));

  pluginSetup = {
    pkg,
    name ? "",
    opts ? {},
    deps ? [],
    optional ? false,
    extraConfigPre ? "",
    extraConfig ? "",
    extraConfigVim ? "",
    keymaps ? [],
  }:
    pkgs.stdenv.mkDerivation (finalAttrs: rec {
      pname = "${name}-setup";
      version = "${pkg.version}";

      dontUnpack = true;

      buildPhases = ["installPhase"];

      setup = pkgs.writeText "${name}-setup-${version}" (builtins.concatStringsSep "\n" [
        extraConfigPre
        (
          if (name != "")
          then ''
            require('${name}').setup(${neovim-utils.toLuaObject opts})
          ''
          else ""
        )
        extraConfig
        (builtins.concatStringsSep "\n" [
          "vim.cmd [["
          extraConfigVim
          "]]"
        ])
        (makeKeymap keymaps)
      ]);

      installPhase = ''
        mkdir -p $out/plugin
        cp $setup $out/plugin/${name}-setup-${version}.lua
      '';
    });

  pack = plugins:
    pkgs.linkFarm "neovim-plugins" (
      (
        map (
          plugin: packagePlugin plugin
        )
        plugins
      )
      ++ (
        map (
          plugin: packagePlugin plugin
        )
        (builtins.concatMap ({deps ? [], ...}: deps) plugins)
      )
    );

  packagePlugin = {
    pkg,
    name ? "",
    opts ? {},
    deps ? [],
    optional ? false,
    extraConfigPre ? "",
    extraConfig ? "",
    extraConfigVim ? "",
    keymaps ? [],
  }: {
    name =
      if optional
      then "pack/${pkg.name}/opt/${pkg.name}"
      else "pack/${pkg.name}/start/${pkg.name}";
    path = pkgs.symlinkJoin {
      name = pkg.name;
      paths =
        [
          pkg
        ]
        ++ (
          if (name != "")
          then [(pluginSetup {inherit pkg name opts deps optional extraConfig extraConfigVim extraConfigPre keymaps;})]
          else []
        );
    };
  };

  setGlobals = globals: (
    builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: value: "vim.g['${name}'] = ${neovim-utils.toLuaObject value}"
      )
      globals
    )
  );

  setOpts = opts: (
    builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: value: "vim.opt.${name} = ${neovim-utils.toLuaObject value}"
      )
      opts
    )
  );

  _on_attach = {
    __raw = ''
      function(client, bufnr)
       	require("lsp_signature").on_attach({
      		bind = true,
      		handler_opts = {
      			border = "rounded",
      		},
      	}, bufnr)
       end
    '';
  };

  _capabilities = {
    __raw = "vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())";
  };

  mkServerConfig = {
    server_name,
    settings ? {},
    on_attach ? null,
    capabilities ? null,
    ...
  }: rec {
    name = server_name;
    on_attach_func =
      if (on_attach == null)
      then _on_attach
      else on_attach;
    capabilities_func =
      if capabilities == null
      then _capabilities
      else capabilities;
    srv_config = neovim-utils.toLuaObject {
      name = name;
      extraOptions =
        {
          settings.${name} = settings;
        }
        // {
          on_attach = on_attach_func;
          capabilities = capabilities_func;
        };
    };
  };

  setupLsp = {servers ? [], ...}: (
    builtins.concatStringsSep "\n" (lib.flatten [
      "local __LspServers = {"
      (map (srv: let s = mkServerConfig srv; in s.srv_config) servers)
      "}"
      ''
        for i, s in ipairs(__LspServers) do
        	require('lspconfig')[s.name].setup(s.extraOptions)
        end

      ''
    ])
  );

  makeAutogroups = autogroups: builtins.concatStringsSep "\n" (map (ag: "vim.api.nvim_create_augroup('${ag}', {clear = false})") autogroups);

  makeAutoCmds = autocmds:
    builtins.concatStringsSep "\n" (map (
        {
          event,
          desc,
          group,
          callback,
          pattern ? null,
        }:
          builtins.concatStringsSep "\n" [
            "vim.api.nvim_create_autocmd(${neovim-utils.toLuaObject event}, {"
            (
              if (pattern == null)
              then ""
              else "pattern = ${neovim-utils.toLuaObject pattern},"
            )
            "desc = '${desc}',"
            "group = '${group}',"
            "callback = ${neovim-utils.toLuaObject callback}"
            "})"
          ]
      )
      autocmds);

  mkConfig = {
    colourscheme ? "default",
    plugins ? [],
    keymaps ? [],
    autogroups ? [],
    autocmds ? [],
    lsp ? {},
    globals ? {},
    opts ? {},
    ...
  }:
    pkgs.writeText "init.lua" (builtins.concatStringsSep "\n" [
      "vim.opt.packpath = '${pack plugins}'"
      (makeAutogroups autogroups)
      (makeAutoCmds autocmds)
      (setGlobals globals)
      (setOpts opts)
      (setupLsp lsp)
      (makeKeymap keymaps)
      "vim.opt.runtimepath:remove(vim.fn.stdpath('config'))"
      "vim.opt.runtimepath:remove(vim.fn.stdpath('config'))"
      "vim.opt.runtimepath:remove(vim.fn.stdpath('data') .. '/site')"
      "vim.cmd[[colorscheme ${colourscheme}]]"
    ]);
in
  pkgs.runCommand "${neovim.meta.mainProgram}" {
    nativeBuildInputs = with pkgs; [
      makeWrapper
    ];
  } ''
     mkdir $out;
     makeWrapper ${neovim}/bin/nvim $out/bin/nvim \
     	--add-flags "-u ${mkConfig config}" \
    --prefix PATH : ${lib.makeBinPath extraPackages}
  ''
