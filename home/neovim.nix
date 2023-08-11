{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      gopls
      nil
      nodePackages.pyright
      nodePackages.bash-language-server
      rubyPackages.solargraph
      terraform-ls
    ];
    extraConfig = ''
      filetype plugin indent on
      syntax on

      " Remove trailing white spaces on save
      autocmd BufWritePre * :%s/\s\+$//e

      set autoread
      set autoindent
      set backspace=2
      " for cross-terminal clipboard support
      set clipboard=unnamed
      set clipboard^=unnamedplus
      set completeopt-=preview
      set colorcolumn=80
      set cursorline
      set encoding=utf-8
      set expandtab
      set hlsearch
      set ignorecase
      set incsearch
      set laststatus=3
      set mouse=a
      set nobackup
      set nocompatible
      set noshowmode
      set noswapfile
      set nowritebackup
      set number
      set relativenumber
      set scrolloff=8
      set shiftwidth=4
      set showcmd
      set sidescrolloff=10
      set smartcase
      set smarttab
      set softtabstop=4
      set spell
      set spelllang=en
      set splitbelow
      set splitright
      set tabstop=4
      set termguicolors
      set timeoutlen=1000
      set ttimeoutlen=0

      highlight Comment gui=italic cterm=italic

      "  Disable Ex mode
      map Q <nop>
      " Move up and down in autocomplete with <c-j> and <c-k>
      inoremap <expr> <C-j> ("\<C-n>")
      inoremap <expr> <C-k> ("\<C-p>")
    '';
    plugins = with pkgs.vimPlugins; [
      colorizer
      vim-commentary
      vim-nix
      vim-terraform
      {
        plugin = indent-blankline-nvim;
        type = " lua";
        config = ''
          require("indent_blankline").setup {}
        '';
      }
      {
        plugin = nvim-lastplace;
        type = "lua";
        config = ''
          require'nvim-lastplace'.setup{}
        '';
      }
      {
        plugin = gruvbox;
        config = ''
          colorscheme gruvbox
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup()
        '';
      }
      {
        plugin = fzf-vim;
        config = ''
          nnoremap <A-l> :BLines<CR>
          nnoremap <A-r> :Rg
          nnoremap <A-g> :GFiles<CR>
          nnoremap <A-b> :Buffers<CR>
          nnoremap <A-f> :Files<CR>
        '';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          -- Setup language servers.
          local lspconfig = require('lspconfig')
          lspconfig.pyright.setup {}
          lspconfig.gopls.setup {}
          lspconfig.solargraph.setup {}
          lspconfig.terraformls.setup {}
          lspconfig.bashls.setup {}
          lspconfig.nil_ls.setup{
            autostart = true,
            settings = {
              ['nil'] = {
                formatting = {
                  command = { "nixpkgs-fmt" },
                },
              },
            },
          }

          -- Global mappings.
          -- See `:help vim.diagnostic.*` for documentation on any of the below functions
          vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
          vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

          -- Use LspAttach autocommand to only map the following keys
          -- after the language server attaches to the current buffer
          vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
              -- Enable completion triggered by <c-x><c-o>
              vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

              -- Buffer local mappings.
              -- See `:help vim.lsp.*` for documentation on any of the below functions
              local opts = { buffer = ev.buf }
              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
              vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
              vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
              vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, opts)
              vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
              vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
              vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
              vim.keymap.set('n', '<space>f', function()
                vim.lsp.buf.format { async = true }
              end, opts)
            end,
          })

          function OrgImports(wait_ms)
            local params = vim.lsp.util.make_range_params()
            params.context = {only = {"source.organizeImports"}}
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
            for _, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
                else
                  vim.lsp.buf.execute_command(r.command)
                end
              end
            end
          end

          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*.go" },
            callback = function()
              OrgImports(1000)
            end,
          })
        '';
      }
    ];
  };
}
