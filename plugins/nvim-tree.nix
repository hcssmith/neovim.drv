{vimPlugins}: {
  pkg = vimPlugins.nvim-tree-lua;
  name = "nvim-tree";
  optional = true;
  deps = [
    {
      pkg = vimPlugins.nvim-web-devicons;
      name = "nvim-web-devicons";
    }
  ];
}
