" 2014-08-27

command  -nargs=* MyProject call s:MyProject(<f-args>)
command  -nargs=* MyProjectLoad call s:MyProjectLoad(<f-args>)
command  -nargs=* MyMapping call s:MyMapping(<f-args>)
command  -nargs=* MPL call s:MyProjectLoad(<f-args>)
command  -nargs=* MPC call s:MyProjectCreat(<f-args>)


function s:MyProjectLoad(...)
    set tags=tags
    cs kill -1
	if a:0 != 0
        if a:1 == '-C'
            cs a cscope.out . -C
        endif
    else
        cs a cscope.out
    endif
    call s:MyMapping()
endfunction

function s:MyProjectCreat(...)
    silent !ctags -R --c++-kinds=+p --fields=+iamS --extra=+q .
    silent !cscope -Rbkq
endfunction

function! s:MyProject( ... )
	if a:0 == 0
        call s:MyProjectCreat()
        call s:MyProjectLoad()
		return
	endif
	if a:1 == 'create'
        call s:MyProjectCreat()
	elseif a:1 == "load"
        call s:MyProjectLoad( a:2 )
	else
		echo "unknow command, please ask river"
	endif
endfunction

function s:MyMapping(...)
    " Mapping cursor for cscope  
    map <S-up>  <ESC>:cprevious<CR>
    map <S-down> <ESC>:cnext<CR>
    map <S-left>  <ESC>:col<CR>:cc<CR>
    map <S-right> <ESC>:cnew<CR>:cc<CR>
    
    " Mapping cursor for ctags
    map <A-up>  <ESC>:tp<CR>
    map <A-down> <ESC>:tn<CR>
    map <A-left>  <ESC>:po<CR>
    map <A-right> <ESC>:ta<CR>
endfunction


function! MySearch(...)
    if a:0 == 0
        return
    endif
    if a:1 == 'tag'
        if exists("a:2")
            let l:s = '/' . input('tag /', a:2)
        else
            let l:s = input('tag :')
        endif
        if l:s == '' || l:s == '/'
            echo "Cancel search!"
            return
        endif
        execute 'tag ' . l:s
        return
    endif
    if a:1 == 'cscope-g'
        let l:s = input('cs f g :')
        if l:s == ''
            echo "Cancel search!"
            return
        endif
        execute 'cs f g ' . l:s
        return
    endif
    if a:1 == 'cscope-e'
        if exists("a:2")
            let l:s = input('cs f e :', a:2)
        else
            let l:s = input('cs f e :')
        endif
        if l:s == ''
            echo "Cancel search!"
            return
        endif
        execute 'cs f e ' . l:s
        return
    endif
    if a:1 == 'vimgrep'
        if exists("a:2")
            let l:s = input('vimgrep :', a:2)
        else
            let l:s = input('vimgrep :')
        endif
        if l:s == ''
            echo "Cancel search!"
            return
        endif
        execute 'vimgrep /' . l:s . '/ **/*.[ch]'
        return
    endif
endfunction

" Mapping key for move cursor around windows
nmap <C-j><C-j> <C-W>j
nmap <C-k><C-k> <C-W>k
nmap <C-l><C-l> <C-W>l
nmap <C-h><C-h> <C-W>h
nmap <C-left> <C-W>h
nmap <C-right> <C-W>l
nmap <C-up> <C-W>k
nmap <C-down> <C-W>j
imap <A-j> <down>
imap <A-k> <up>
imap <A-l> <Right>
imap <A-h> <Left>

" Copy/Paste
vmap <C-c> "+y
imap <C-v> <ESC>"+gp
cmap <C-v> <C-r>+

nmap K a_<Esc>r

command! -nargs=+ CSf :cs f f <args>
command! -nargs=+ CSe :cs f e <args>
command! -nargs=+ CSg :cs f g <args>
command! -nargs=+ CSt :cs f t <args>
command! -nargs=+ CSc :cs f c <args>

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

map <MiddleMouse> <ESC><LeftMouse>:cs f g <C-R>=expand("<cword>")<CR><CR>
imap <MiddleMouse> <ESC><LeftMouse>:cs f g <C-R>=expand("<cword>")<CR><CR>
map <C-MiddleMouse> <ESC><LeftMouse>:cs f c <C-R>=expand("<cword>")<CR><CR>
imap <C-MiddleMouse> <ESC><LeftMouse>:cs f c <C-R>=expand("<cword>")<CR><CR>
map <S-MiddleMouse> <ESC><LeftMouse>:cs f c <C-R>=expand("<cword>")<CR><CR>
imap <S-MiddleMouse> <ESC><LeftMouse>:cs f c <C-R>=expand("<cword>")<CR><CR>
map <S-LeftMouse> <ESC><C-o>
map <S-RightMouse> <ESC><C-i>
imap <S-LeftMouse> <ESC><C-o>
imap <S-RightMouse> <ESC><C-i>

map #1 <ESC>:help<SPACE> 
map <C-F1> <ESC>:help <C-R>=expand("<cword>")<CR><CR>
map <S-F1> <ESC>:help <C-R>=expand("<cword>")<CR><CR>
map #2 <ESC>:MPL<CR><ESC>:cs f g main<CR>

nmap #3 <ESC>:call MySearch('tag')<CR>
vmap #3 <ESC>:call MySearch('tag', '<C-R>*')<CR>
map <C-F3> <ESC>:call MySearch('cscope-g')<CR>
map <S-F3> <ESC>:call MySearch('cscope-g')<CR>

nmap #4 <ESC>:call MySearch('cscope-e')<CR>
vmap #4 <ESC>:call MySearch('cscope-e', '<C-R>*')<CR>
nmap <C-F4> <ESC>:call MySearch('vimgrep')<CR>
nmap <S-F4> <ESC>:call MySearch('vimgrep')<CR>
vmap <C-F4> <ESC>:call MySearch('vimgrep', '<C-R>*')<CR>
vmap <S-F4> <ESC>:call MySearch('vimgrep', '<C-R>*')<CR>

map #5 <ESC>'A
map <C-F5> <ESC>mA:echo "'A Mark line:" . <C-R>=line('.')<CR><CR>
map <S-F5> <ESC>mA:echo "'A Mark line:" . <C-R>=line('.')<CR><CR>
map <A-F5> <ESC>mA:echo "'A Mark line:" . <C-R>=line('.')<CR><CR>

map #6 <ESC>'B
map <C-F6> <ESC>mB:echo "'B Mark line:" . <C-R>=line('.')<CR><CR>
map <S-F6> <ESC>mB:echo "'B Mark line:" . <C-R>=line('.')<CR><CR>
map <A-F6> <ESC>mB:echo "'B Mark line:" . <C-R>=line('.')<CR><CR>

map <F10> <ESC>:w<CR>:make<CR>

"Plugins setting
let Tlist_Use_Right_Window = 1

set fileformat=unix
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set fileencodings=utf-8,gbk,ucs-bom,cp936,latin1
set nobackup
set nocp
set hlsearch
set incsearch
set ignorecase
filetype plugin on 
set cscopequickfix=s-,c-,d-,i-,t-,e-,g-,f- 
set completeopt-=preview
set history=700
set nu
set numberwidth=1

cd %:p:h
set path=""
set path+=./**

set wildmenu
set wildmode=full
set wildignore=*.o
if exists("&wildignorecase")
    set wildignorecase
endif

colorscheme koehler
hi Visual  guifg=#000000 guibg=#FFFFFF gui=none
"set lines=40 columns=70

" GUI setting
"Toggle Menu and Toolbar
set guifont=Monospace\ 12
set guioptions+=c
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
nmap  <F12> :call MyToggle()<CR>

function! MyToggle(...)
    if &guioptions =~# 'T'
        set guioptions-=m
        set guioptions-=T
        set guioptions-=r
        set guioptions-=L
        imap <C-v> <ESC>"+gp
        cmap <C-v> <C-r>+
    else
        set guioptions+=m
        set guioptions+=T
        set guioptions+=r
        set guioptions+=L
        cunmap <C-v>
        iunmap <C-v>
    endif
endfunction
