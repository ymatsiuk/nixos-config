{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
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
      set laststatus=2
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
      "  Disable arrow keys
      noremap <up> <nop>
      noremap <down> <nop>
      noremap <left> <nop>
      noremap <right> <nop>
      inoremap <up> <nop>
      inoremap <down> <nop>
      inoremap <left> <nop>
      inoremap <right> <nop>
      nnoremap <up> <nop>
      nnoremap <down> <nop>
      nnoremap <left> <nop>
      nnoremap <right> <nop>
      vnoremap <up> <nop>
      vnoremap <down> <nop>
      vnoremap <left> <nop>
      vnoremap <right> <nop>
      " Disable PageUp and PageDown
      inoremap <PageUp> <nop>
      inoremap <PageDown> <nop>
      nnoremap <PageUp> <nop>
      nnoremap <PageDown> <nop>
      vnoremap <PageUp> <nop>
      vnoremap <PageDown> <nop>
      cnoremap <PageUp> <nop>
      cnoremap <PageDown> <nop>
      noremap <PageUp> <nop>
      noremap <PageDown> <nop>
      " Remap splits navigation to just CTRL + hjkl
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l
      " Make adjusing split sizes a bit more friendly
      noremap <silent> <C-Left> :vertical resize +2<CR>
      noremap <silent> <C-Right> :vertical resize -2<CR>
      noremap <silent> <C-Up> :resize +2<CR>
      noremap <silent> <C-Down> :resize -2<CR>
      " Move up and down in autocomplete with <c-j> and <c-k>
      inoremap <expr> <C-j> ("\<C-n>")
      inoremap <expr> <C-k> ("\<C-p>")
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = vim-go;
        config = ''
          let g:go_fmt_command = "goimports"
          let g:go_highlight_functions = 1
          let g:go_highlight_methods = 1
          let g:go_highlight_structs = 1
          let g:go_highlight_operators = 1
          let g:go_highlight_build_constraints = 1
        '';
      }
      {
        plugin = vim-airline;
        config = ''
          let g:airline_theme='gruvbox'
          let g:airline_powerline_fonts=1
          let g:airline#extensions#branch#enabled = 1
          let g:airline#extensions#branch#format = 2
          let g:airline#themes#clean#palette = 1
          let g:airline#extensions#tabline#enabled = 1
          let g:airline#extensions#tabline#formatter = 'unique_tail'
        '';
      }
      {
        plugin = vim-airline-themes;
        config = ''
          let g:airline_theme='gruvbox'
        '';
      }
      {
        plugin = gruvbox;
        config = ''
          colorscheme gruvbox
        '';
      }
      {
        plugin = vim-nix;
        config = ''
          " Format with nixpkgs-fmt on write
          autocmd BufWritePost *.nix !nixpkgs-fmt %
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
      colorizer
      vim-commentary
      vim-fugitive
      vim-lastplace
      vim-terraform
    ];
  };
}

