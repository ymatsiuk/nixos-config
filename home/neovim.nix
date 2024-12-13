{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      gopls
      gotools
      nil
      pyright
      nodePackages.bash-language-server
      terraform-ls
    ];
    extraLuaConfig = ''
      -- Disable netrw in favor of nvim-tree.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- Options
      vim.opt.backup = false
      vim.opt.clipboard = "unnamed,unnamedplus"
      vim.opt.colorcolumn = "80"
      vim.opt.cursorline = true
      vim.opt.laststatus = 3
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.scrolloff = 8
      vim.opt.showmode = false
      vim.opt.swapfile = false
      vim.opt.termguicolors = true
      vim.opt.diffopt = "vertical,iwhite,hiddenoff,foldcolumn:0,context:4,algorithm:histogram,indent-heuristic"

      -- Move selection up/down
      vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
      vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
      -- Insert into selection without copying it
      vim.keymap.set("x", "<space>p", [["_dP]])
      -- Delete without placing into the register
      vim.keymap.set({"n", "v"}, "<space>d", [["_d]])
      -- Don't jump when merge lines
      vim.keymap.set("n", "J", "mzJ`z")
      -- Stay in the middle of the screen while scrolling
      vim.keymap.set("n", "<C-d>", "<C-d>zz")
      vim.keymap.set("n", "<C-u>", "<C-u>zz")
      -- Keep cursor in the middle of the screen while searching
      vim.keymap.set("n", "n", "nzzzv")
      vim.keymap.set("n", "N", "Nzzzv")
      -- Disable Ex mode
      vim.keymap.set("n", "Q", "<nop>")
      -- Disable space in normal/visual modes
      vim.keymap.set({ "n", "v" }, "<space>", "<nop>", { silent = true })
      -- Toggle nvim-tree
      vim.keymap.set({ "n" }, "<space>tt", ":NvimTreeToggle<CR>", { silent = true })
      vim.keymap.set({ "n" }, "<space>tf", ":NvimTreeFocus<CR>", { silent = true })

      -- Remove trailing white spaces on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        command = ":%s/\\s\\+$//e"
      })
    '';
    plugins = with pkgs.vimPlugins; [
      colorizer
      copilot-vim
      vim-helm
      vim-nix
      vim-sleuth
      vim-terraform
      {
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
          require("nvim-web-devicons").setup()
        '';
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("nvim-tree").setup({
            disable_netrw = true,
            hijack_netrw = true,
            hijack_cursor = true,
            sync_root_with_cwd = true,
          })
        '';
      }
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require("Comment").setup()
        '';
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          vim.opt.foldmethod = "expr"
          vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
          vim.opt.foldenable = false

          require("nvim-treesitter.configs").setup({
            indent = { enable = true, },
            highlight = { enable = true, },
          })
        '';
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          vim.opt.list = true
          vim.opt.listchars:append "space:⋅"
          vim.opt.listchars:append "eol:↴"

          require("ibl").setup({
            scope = { enabled = false, },
          })
        '';
      }
      {
        plugin = nvim-lastplace;
        type = "lua";
        config = ''
          require("nvim-lastplace").setup()
        '';
      }
      {
        plugin = gruvbox-nvim;
        type = "lua";
        config = ''
          require("gruvbox").setup()
          -- Setup should be always called before setting the colorscheme
          vim.cmd.colorscheme("gruvbox")
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require("lualine").setup()
        '';
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require("telescope").setup()
          local builtin = require("telescope.builtin")
          vim.keymap.set("n", "<space>ff", builtin.find_files, { desc = "Telescope find files" })
          vim.keymap.set("n", "<space>fg", builtin.live_grep, { desc = "Telescope live grep" })
          vim.keymap.set("n", "<space>fb", builtin.buffers, { desc = "Telescope buffers" })
          vim.keymap.set("n", "<space>fc", builtin.current_buffer_fuzzy_find, { desc = "Telescope current buffer" })
          vim.keymap.set("n", "<space>fh", builtin.help_tags, { desc = "Telescope help tags" })
        '';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          -- Setup language servers.
          local lspconfig = require("lspconfig")
          lspconfig.pyright.setup {}
          lspconfig.gopls.setup {}
          lspconfig.terraformls.setup {}
          lspconfig.bashls.setup {}
          lspconfig.nil_ls.setup{
            autostart = true,
            settings = {
              ["nil"] = {
                formatting = {
                  command = { "nixfmt" },
                },
              },
            },
          }

          -- Global mappings.
          -- See `:help vim.diagnostic.*` for documentation on any of the below functions
          vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
          vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

          -- Use LspAttach autocommand to only map the following keys
          -- after the language server attaches to the current buffer
          vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
              -- Enable completion triggered by <c-x><c-o>
              vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

              -- Buffer local mappings.
              -- See `:help vim.lsp.*` for documentation on any of the below functions
              local opts = { buffer = ev.buf }
              vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
              vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
              vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
              vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
              vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
              vim.keymap.set("n", "<space>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, opts)
              vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
              vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
              vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
              vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
              vim.keymap.set("n", "<space>f", function()
                vim.lsp.buf.format { async = true }
              end, opts)
            end,
          })

          -- Autoimport and autoformat for Go files
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
              local params = vim.lsp.util.make_range_params()
              params.context = {only = {"source.organizeImports"}}
              local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
              for cid, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                  if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                  end
                end
              end
              vim.lsp.buf.format({async = false})
            end
          })

          -- Autoformat terraform files on save
          vim.api.nvim_create_autocmd({"BufWritePre"}, {
            pattern = {"*.tf", "*.tfvars"},
            callback = function()
              vim.lsp.buf.format()
            end,
          })
        '';
      }
    ];
  };
}
