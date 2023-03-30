{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      gopls
      rnix-lsp
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
          local nvim_lsp = require('lspconfig')

          -- Use an on_attach function to only map the following keys
          -- after the language server attaches to the current buffer
          local on_attach = function(client, bufnr)
            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

            -- Enable completion triggered by <c-x><c-o>
            buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Mappings.
            local opts = { noremap=true, silent=true }

            -- See `:help vim.lsp.*` for documentation on any of the below functions
            buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
            buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
            buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
            buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
            buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
            buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
            buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
            buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
            buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

          end

          -- Use a loop to conveniently call 'setup' on multiple servers and
          -- map buffer local keybindings when the language server attaches
          local servers = { 'rnix', 'gopls', 'pyright', 'solargraph', 'terraformls', 'bashls' }
          for _, lsp in ipairs(servers) do
            nvim_lsp[lsp].setup {
              on_attach = on_attach,
              flags = {
                debounce_text_changes = 150,
              }
            }
          end

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
