if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

set number
syntax on
"set cindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set ignorecase
set smartcase
set nowrapscan

"----------------------------------------
" ɽ������
"----------------------------------------
"���ץ�å���(��ư���Υ�å�����)��ɽ�����ʤ�
"set shortmess+=I
"���顼���β��ȥӥ��奢��٥������(gvim��.gvimrc������)
set noerrorbells
set novisualbell
set visualbell t_vb=
"�ޥ���¹���ʤɤβ��̺������Ԥ�ʤ�
"set lazyredraw
"Windows�ǥǥ��쥯�ȥ�ѥ��ζ��ڤ�ʸ��ɽ���� / ��Ȥ���褦�ˤ���
set shellslash
"���ֹ�ɽ��
set number
"��̤��б�ɽ������
set showmatch matchtime=1
"���֤�����
"set ts=4 sw=4 sts=4
"��ưŪ�˥���ǥ�Ȥ���
"set autoindent
"C����ǥ�Ȥ�����
set cinoptions+=:0
"�����ȥ��ɽ��
set title
"���ޥ�ɥ饤��ι⤵ (gvim��gvimrc�ǻ���)
set cmdheight=2
set laststatus=2
"���ޥ�ɤ򥹥ơ������Ԥ�ɽ��
set showcmd
"���̺Ǹ�ιԤ�Ǥ���¤�ɽ������
set display=lastline
"Tab��������Ⱦ�ѥ��ڡ���������Ū��ɽ������
"set list
"set listchars=tab:^\ ,trail:~

" �ϥ��饤�Ȥ�ͭ���ˤ���
if &t_Co > 2 || has('gui_running')
  syntax on
endif

""""""""""""""""""""""""""""""
"���ơ������饤���ʸ�������ɤ�BOM��16��ɽ����ɽ��
"iconv�����Ѳ�ǽ�ξ�硢����������ʸ�������ɤ򥨥󥳡��ɤ˱�����ɽ���ˤ���FencB()�����
""""""""""""""""""""""""""""""
if has('iconv')
  set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']['.&ff.']'}%=[0x%{FencB()}]\ (%v,%l)/%L%8P\
else
  set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']['.&ff.']'}%=\ (%v,%l)/%L%8P\
endif
		
function! FencB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return s:Byte2hex(s:Str2byte(c))
endfunction

function! s:Str2byte(str)
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

function! s:Byte2hex(bytes)
  return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
endfunction

set runtimepath+=~/vimruntime

" Auto JDoc Commands
autocmd FileType javascript nmap <C-c>c :call JsJDoc()<CR>
autocmd FileType php nmap <C-c>c :call PhpJDoc()<CR>

" Insert JDoc Comment
" param summary: Summary of the function
" param args: list of arguments' name
function! AddJDocComment(summary, args)
    let c = indent(".") / &tabstop
    let top = a:firstline - 1 
    let l = a:firstline - 1 
    let s = ''
    while len(s) < (c) 
    let s = s . "\t"
    endwhile
       
    call append(l, s . '/**')
    let l+=1
    call append(l, s . ' * ' . a:summary)
    let l+=1
       
    for arg in a:args
        call append(l, s . ' * @param ' . matchstr(arg, '[^$].*') . ' ')
        let l+=1
    endfor

    call append(l, s . ' * @return ')
    let l+=1
    call append(l, s . ' */')

    call cursor(top+2, 80) 
endfunction

" Insert JDoc Comment in Js source code
function! JsJDoc()
    let args = split(matchstr(getline('.'), 'function(\zs.*\ze)'),' *, *')
    call AddJDocComment('', args)
endfunction

" Insert JDoc Comment in PHP source code
function! PhpJDoc()
    let args = split(matchstr(getline('.'), 'function [^(]*(\zs.*\ze)'),' *, *')
    call AddJDocComment('', args)
endfunction

" indent settings
set tabstop=4
set autoindent
set expandtab
set shiftwidth=4

set nowrap

source ~/.vim/conf.d/*.rc

