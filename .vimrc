" set autoindent
set number

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
	set nobackup	" do not keep a backup file, use versions instead
else
	set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	" use plugin manage
	call pathogen#runtime_append_all_bundles()
	filetype on
	filetype plugin on
	filetype plugin indent on

	"omni-completion
	set completeopt=longest,menuone

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
	au!

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" For python files config (no tab)
	autocmd FileType python setlocal et | setlocal sta | setlocal sw=4
	autocmd FileType python imap <silent> <buffer> . .<C-X><C-P>
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	" Also don't do it when the mark is in the first line, that is the default
	" position when opening a file.
	autocmd BufReadPost *
	\ if line("'\"") > 1 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif

	augroup END

else

	set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set tabstop=4
set shiftwidth=4

" 单个文件编译
map <F5> <esc>:call Do_OneFileMake()<CR>
map! <F5> <esc>:call Do_OneFileMake()<CR>
function Do_OneFileMake()

	execute ":w"
  	if &filetype=="c"
		set makeprg=gcc\ -Wall\ -o\ %<.out\ %
		"set makeprg=gcc\ -Wall\ `pkg-config\ fuse\ --cflags\ --libs`\ %\ -o\ %<.out
		execute "silent make"
   		execute "!./%<.out"
	endif
  	if &filetype=="cpp"
		set makeprg=g++\ -Wall\ -o\ %<.out\ %
		execute "silent make"
   		execute "!./%<.out"
  	endif
	if &filetype=="php"
		set makeprg=php\ -n\ -l\ %
		set shellpipe=>
		set errorformat=%m\ in\ %f\ on\ line\ %l
		execute "silent make"
	endif
	if &filetype=="python"
	setlocal makeprg=python\ %
	setlocal errorformat=
        \%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
        \%C\ \ \ \ %.%#,
        \%+Z%.%#Error\:\ %.%#,
        \%A\ \ File\ \"%f\"\\\,\ line\ %l,
        \%+C\ \ %.%#,
        \%-C%p^,
        \%Z%m,
        \%-G%.%#
	"set makeprg=pylint --reports=n --output-format=parseable %:p
	"set errorformat=%f:%l: %m

  	execute "make %"
	endif
  	execute "cw"

endfunction

"进行make的设置
map <F6> :call Do_make()<CR>
map <c-F6> :silent make clean<CR>
function Do_make()
	set makeprg=make
  	execute "silent make"
  	execute "copen"
endfunction  

"NERDTree
map <F9> <esc>:NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

"Taglist
map <F3> <esc>:silent! Tlist<CR>
let Tlist_Ctags_Cmd='ctags'
let Tlist_Use_Right_Window=1
let Tlist_Show_One_File=0
let Tlist_File_Fold_Auto_Close=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Process_File_Always=0
let Tlist_Inc_Winwidth=0

"Set to auto read when a file is changed from the outside
if exists("&autoread")
	set autoread
endif

"Python.vim
let python_highlight_all=1

"supertab.vim
"let g:SuperTabDefaultCompletionType="context"
"let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
"let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
"let g:SuperTabContextDiscovery = 
"	\ ["&completefunc:<c-p> &omnifunc:<c-x><c-o>"]

