[
  {
    action = "<Esc>";
    lua = false;
    key = "jk";
    mode = ["i"];
  }
  {
    action = "<C-\\\\><C-N>";
    lua = false;
    key = "jk";
    mode = ["t"];
  }
  {
    action = "<Cmd>NvimTmuxNavigateLeft<CR>";
    lua = false;
    key = "<C-h>";
  }
  {
    action = "<Cmd>NvimTmuxNavigateDown<CR>";
    lua = false;
    key = "<C-j>";
  }
  {
    action = "<Cmd>NvimTmuxNavigateUp<CR>";
    lua = false;
    key = "<C-k>";
  }
  {
    action = "<Cmd>NvimTmuxNavigateRight<CR>";
    lua = false;
    key = "<C-l>";
  }
  {
    action = "<Cmd>NvimTmuxNavigateLeft<CR>";
    lua = false;
    key = "<C-Left>";
  }
  {
    action = "<Cmd>NvimTmuxNavigateDown<CR>";
    lua = false;
    key = "<C-Down>";
  }
  {
    action = "<Cmd>NvimTmuxNavigateUp<CR>";
    lua = false;
    key = "<C-Up>";
  }
  {
    action = "<Cmd>NvimTmuxNavigateRight<CR>";
    lua = false;
    key = "<C-Right>";
  }
  {
    action = ":cn<CR>";
    lua = false;
    key = "]q";
    opts.silent = true;
  }
  {
    action = ":cp<CR>";
    lua = false;
    key = "[q";
    opts.silent = true;
  }
  {
    action = ":clast<CR>";
    lua = false;
    key = "[Q";
    opts.silent = true;
  }
  {
    action = ":cfirst<CR>";
    lua = false;
    key = "[Q";
    opts.silent = true;
  }
  {
    action = ":m '>+1<CR>gv=gv";
    lua = false;
    key = "J";
    mode = ["v"];
    opts.silent = true;
  }
  {
    action = ":m '>-2<CR>gv=gv";
    lua = false;
    key = "K";
    mode = ["v"];
    opts.silent = true;
  }
]
