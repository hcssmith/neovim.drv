[
  {
    desc = "Set correct filetype for .nw files";
    event = ["BufEnter"];
    group = "UserUtil";
    pattern = ["*.nw"];
    callback.__raw = ''
      function(ev)
        vim.bo[ev.buf].filetype = "tex"
      end
    '';
  }
  {
    desc = "Enable wrap on certain filetypes";
    event = "BufEnter";
    group = "UserUtil";
    pattern = ["*.nw" "*.tex" "*.norg" "*.md" "*.txt"];
    callback.__raw = ''
      function(ev)
        vim.bo[ev.buf].textwidth = 80
        vim.bo[ev.buf].wrapmargin = 80
        vim.cmd.setlocal('wrap')
      end
    '';
  }
]
