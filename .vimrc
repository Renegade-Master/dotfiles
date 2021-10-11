" ### VIM Configuration File ###

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Set to prevent VIM starting up in REPLACE mode on WSL
nnoremap <esc>^[ <esc>^[

" Attempt to detect filetype
if has('filetype')
  filetype indent plugin on
endif

" Syntax highlighting
if has('syntax')
  syntax on
endif

" Enable use of the mouse for all modes
if has('mouse')
  set mouse=a
endif

" Command line completion
set wildmenu

" Suggest commands
set showcmd

" Highlight searches
set hlsearch

" Case insensitive search unless using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Indentation settings for using 4 spaces instead of tabs.
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=8
set expandtab

" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
set shiftwidth=4
set tabstop=4

" Colour Scheme
colorscheme elflord

" Set guide at 72, 80, and 120 characters
set colorcolumn=72,80,120
highlight ColorColumn ctermbg=darkgrey ctermfg=white guibg=darkgrey
