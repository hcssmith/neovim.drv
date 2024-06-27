{vimPlugins, ...}: {
  pkg = vimPlugins.gitsigns-nvim;
  name = "gitsigns";
  opts = {
    numhl = true;
    current_line_blame = true;
    current_line_blame_opts = {
      delay = 500;
      virt_text_pos = "right_align";
    };
  };
  keymaps = [
    {
      action = "function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        require('gitsigns').nav_hunk('next')
      end
    end";
      lua = true;
      key = "]c";
      mode = ["n"];
    }
    {
      action = "function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        require('gitsigns').nav_hunk('prev')
      end
    end";
      lua = true;
      key = "[c";
      mode = ["n"];
    }
  ];
}
