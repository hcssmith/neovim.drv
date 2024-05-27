{vimPlugins, ...}: {
  pkg = vimPlugins.git-worktree-nvim;
  optional = true;
  name = "git-worktree";
  extraConfig = "require('telescope').load_extension('git_worktree')";
  keymaps = [
    {
      action = "function () require('telescope').extensions.git_worktree.create_git_worktree() end";
      key = "<leader>gwc";
    }
    {
      action = "function () require('telescope').extensions.git_worktree.git_worktrees() end";
      key = "<leader>gwl";
    }
  ];
}
