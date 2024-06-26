[
  {
    event = "LspAttach";
    desc = "Setup Lsp keybindings on buffer when LSP is attached";
    group = "UserLsp";
    callback. __raw = ''
      function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>vf", vim.lsp.buf.format, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>vqf', vim.diagnostic.setqflist, opts)
        vim.keymap.set("n", "<leader>pd", function() require('lspsaga.definition'):init(1, 1) end, opts)
        vim.keymap.set("n", "<leader>ca", function() require('lspsaga.codeaction'):code_action() end, opts)
        vim.keymap.set("n", "<leader>o", function() require('lspsaga.symbol'):outline() end, opts)
        vim.keymap.set("n", "K", function() require('lspsaga.hover'):render_hover_doc() end, opts)
      end
    '';
  }
  {
    event = "BufWritePre";
    desc = "Auto run lsp format on save if a lsp client with the correct capabilitiy is connected";
    group = "UserLsp";
    callback.__raw = ''
      function (ev)
        local clients = vim.lsp.get_clients({
          bufnr = ev.buf
        })
        for _, client in pairs(clients) do
          if client.attached_buffers[ev.buf] == true and client.server_capabilities.documentFormattingProvider then
            local view = vim.fn.winsaveview()
            vim.lsp.buf.format()
            vim.diagnostic.enable(true, {bufnr = ev.buf})
            vim.fn.winrestview(view)
         		return
          end
        end
        if vim.bo.filetype == "sh" then
          local view = vim.fn.winsaveview()
          vim.cmd('silent %!shfmt %')
          vim.diagnostic.enable(true, {bufnr = ev.buf})
          vim.fn.winrestview(view)
        end
      end
    '';
  }
  {
    event = "InsertEnter";
    desc = "Enable Inlay hints if a LSP with the capability is attached.";
    group = "UserLsp";
    callback.__raw = ''
      function(ev)
        local clients = vim.lsp.get_clients({
          bufnr = ev.buf
        })
        for _, client in pairs(clients) do
          if client.attached_buffers[ev.buf] == true and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end
        end
      end
    '';
  }
  {
    event = "InsertLeave";
    desc = "Disable inlay hints if enabled when leaving insert mode";
    group = "UserLsp";
    callback.__raw = ''
      function(ev)
        if vim.lsp.inlay_hint.is_enabled({bufnr = ev.buf}) then
          vim.lsp.inlay_hint.enable(false)
        end
      end
    '';
  }
]
