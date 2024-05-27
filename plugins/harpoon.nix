{vimPlugins, ...}: {
  pkg = vimPlugins.harpoon;
  name = "harpoon";
  extraConfig = "require('telescope').load_extension('harpoon')";
  keymaps = [
    {
      key = "<leader>hl";
      action = "function () require('harpoon.ui').toggle_quick_menu() end";
    }
    {
      key = "<leader>hm";
      action = "function () require('harpoon.mark').add_file() end";
    }
    {
      key = "<leader>h1";
      action = "function () require('harpoon.ui').nav_file(1) end";
    }
    {
      key = "<leader>h2";
      action = "function () require('harpoon.ui').nav_file(2) end";
    }
    {
      key = "<leader>h3";
      action = "function () require('harpoon.ui').nav_file(3) end";
    }
    {
      key = "<leader>h4";
      action = "function () require('harpoon.ui').nav_file(4) end";
    }
    {
      key = "<leader>h5";
      action = "function () require('harpoon.ui').nav_file(5) end";
    }
    {
      key = "<leader>h6";
      action = "function () require('harpoon.ui').nav_file(6) end";
    }
    {
      key = "<leader>h7";
      action = "function () require('harpoon.ui').nav_file(7) end";
    }
    {
      key = "<leader>h8";
      action = "function () require('harpoon.ui').nav_file(8) end";
    }
    {
      key = "<leader>h9";
      action = "function () require('harpoon.ui').nav_file(9) end";
    }
  ];
}
