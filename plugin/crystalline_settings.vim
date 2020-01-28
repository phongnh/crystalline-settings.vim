if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    finish
endif
let g:loaded_vim_crystalline_settings = 1

let s:save_cpo = &cpo
set cpo&vim

" Window width
let s:small_window_width  = 80
let s:normal_window_width = 100

let s:filename_modes = {
            \ '__Tagbar__':           'Tagbar',
            \ '__Gundo__':            'Gundo',
            \ '__Gundo_Preview__':    'Gundo Preview',
            \ '[BufExplorer]':        'BufExplorer',
            \ '[Command Line]':       'Command Line',
            \ '[Plugins]':            'Plugins',
            \ '__committia_status__': 'Committia Status',
            \ '__committia_diff__':   'Committia Diff',
            \ }

let s:filetype_modes = {
            \ 'ctrlp':             'CtrlP',
            \ 'leaderf':           'LeaderF',
            \ 'netrw':             'NetrwTree',
            \ 'nerdtree':          'NERDTree',
            \ 'startify':          'Startify',
            \ 'vim-plug':          'Plug',
            \ 'unite':             'Unite',
            \ 'vimfiler':          'VimFiler',
            \ 'vimshell':          'VimShell',
            \ 'help':              'Help',
            \ 'qf':                '%q %{get(w:, "quickfix_title", "")}',
            \ 'godoc':             'GoDoc',
            \ 'gedoc':             'GeDoc',
            \ 'gitcommit':         'Commit Message',
            \ 'fugitiveblame':     'FugitiveBlame',
            \ 'gitmessengerpopup': 'Git Messenger',
            \ 'agit':              'Agit',
            \ 'agit_diff':         'Agit Diff',
            \ 'agit_stat':         'Agit Stat',
            \ }

function! s:hi(group)
    return printf('%%#%s#', a:group)
endfunction

function! s:GetCurrentDir() abort
    let dir = fnamemodify(getcwd(), ':~:.')
    if empty(dir)
        let dir = getcwd()
    endif
    return dir
endfunction

function! CrystallineFileType() abort
    if exists('*WebDevIconsGetFileTypeSymbol')
        return WebDevIconsGetFileTypeSymbol() . ' '
    endif
    return &ft
endfunction

function! CrystallineFileEncoding() abort
    let encoding = &fenc !=# '' ? &fenc : &enc
    if encoding !=? 'utf-8'
        return '[' . encoding . ']'
    endif
    return ''
endfunction

function! CrystallineFileFormat() abort
    if exists('*WebDevIconsGetFileFormatSymbol')
        return WebDevIconsGetFileFormatSymbol() . ' '
    endif
    return &ff !=? 'unix' ? '[' . &ff . ']' : ''
endfunction

function! s:CrystallineSpacesOrTabSize() abort
    let shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    return printf(' %s: %d ', (&expandtab ? 'Spaces' : 'Tab Size'), shiftwidth)
endfunction

function! s:CrystallinePasteAndSpell() abort
    let ary = []

    if &paste
        call add(ary, '[PASTE]')
    endif

    if &spell
        call add(ary, printf('[SPELL %s]', toupper(substitute(&spelllang, ',', '/', 'g'))))
    endif

    if len(ary)
        return ' ' . join(ary, ' ') . ' '
    endif

    return ''
endfunction

function! s:GetClipboardStatus() abort
    if match(&clipboard, 'unnamed') > -1
        return '@ '
    endif
    return ''
endfunction

function! s:CrystallineCustomMode() abort
    let filetype = getbufvar(bufnr('%'), '&filetype')
    if has_key(s:filetype_modes, filetype)
        let new_mode = s:filetype_modes[filetype]
    else
        let fname = fnamemodify(bufname('%'), ':t')
        let new_mode = s:filename_modes[fname]
    endif
    return crystalline#mode_color() . printf(' %s ', new_mode)
endfunction

function! s:IsCustomMode() abort
    let filetype = getbufvar(bufnr('%'), '&filetype')
    let fname = fnamemodify(bufname('%'), ':t')
    return has_key(s:filetype_modes, filetype) || has_key(s:filename_modes, fname)
endfunction

function! s:IsSmallWindow(winnum) abort
    return winwidth(a:winnum) < s:small_window_width
endfunction

function! s:IsNormalWindow(winnum) abort
    return winwidth(a:winnum) >= s:normal_window_width
endfunction

function! s:BranchShorten(branch, length)
    let branch = a:branch

    if strlen(branch) > a:length
        let branch = pathshorten(branch)
    endif

    if strlen(branch) > a:length
        let branch = fnamemodify(branch, ':t')
    endif

    return branch
endfunction

function! s:FormatBranch(branch) abort
    if s:IsSmallWindow(0)
        return ''
    endif

    if s:IsNormalWindow(0)
        return s:BranchShorten(a:branch, 50)
    endif

    return s:BranchShorten(a:branch, 30)
endfunction

function! CrystallineBranch() abort
    if exists('*FugitiveHead')
        return s:FormatBranch(FugitiveHead())
    elseif exists('*fugitive#head')
        return s:FormatBranch(fugitive#head())
    elseif exists(':Gina') == 2
        return s:FormatBranch(gina#component#repo#branch())
    else
        return fnamemodify(getcwd(), ':t')
    endif
endfunction

function! StatusLine(current, width)
    let l:s = ''

    if a:current && s:IsCustomMode()
        let l:s .= s:CrystallineCustomMode() . s:GetClipboardStatus() . crystalline#right_mode_sep('')
        return l:s
    endif

    if a:current
        let l:s .= crystalline#mode() . s:GetClipboardStatus() . crystalline#right_mode_sep('')
    else
        let l:s .= s:hi('CrystallineInactive')
    endif
    let l:s .= ' %f%h%w%m%r '

    if a:current
        let l:s .= crystalline#right_sep('', 'Fill') . ' %{CrystallineBranch()}'
    endif

    let l:s .= '%='
    if a:current
        let l:s .= s:CrystallinePasteAndSpell()
        let l:s .= crystalline#left_sep('', 'Fill')
        let l:s .= s:CrystallineSpacesOrTabSize()
        let l:s .= crystalline#left_mode_sep('')
    endif

    if a:width > 80
        let l:s .= ' %{CrystallineFileType()}%{CrystallineFileEncoding()}%{CrystallineFileFormat()} '
    else
        let l:s .= ' '
    endif

    return l:s
endfunction

function! TabLine()
    let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
    return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=' . s:hi('CrystallineTab') . l:vimlabel
endfunction

let g:crystalline_enable_sep    = get(g:, 'crystalline_powerline', 0)
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn    = 'TabLine'
let g:crystalline_theme         = 'solarized'

" CtrlP Integration
let g:ctrlp_status_func = {
            \ 'main': 'CtrlPMainStatusLine',
            \ 'prog': 'CtrlPProgressStatusLine',
            \ }

function! CtrlPMainStatusLine(focus, byfname, regex, prev, item, next, marked) abort
    let item = s:hi('CrystallineNormalModeToLine') . 
                \ s:hi('Character') . ' ' . a:item . ' %*' .
                \ s:hi('Crystalline')
    let dir  = s:GetCurrentDir()
    return printf('%s CtrlP %s %s %s %s %s %s %%=%%<%s %s %s %s %s ',
                \ crystalline#mode_color(),
                \ crystalline#right_mode_sep(''),
                \ a:prev,
                \ item,
                \ a:next,
                \ crystalline#right_sep('', 'Fill'),
                \ a:marked,
                \ a:focus,
                \ crystalline#left_sep('', 'Fill'),
                \ a:byfname,
                \ crystalline#left_mode_sep(''),
                \ dir)
endfunction

function! CtrlPProgressStatusLine(len) abort
    return printf(' %s %%=%%< %s ', a:len, s:GetCurrentDir())
endfunction

" Tagbar Integration
let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
    if empty(a:flags)
        return printf('%s [%s] %s %s %s',
                    \ crystalline#mode_color(),
                    \ a:sort,
                    \ crystalline#right_mode_sep(''),
                    \ a:fname,
                    \ crystalline#right_sep('', 'Fill')
                    \ )
    else
        return printf('%s [%s] %s [%s] %s %s',
                    \ crystalline#mode_color(),
                    \ a:sort,
                    \ crystalline#right_mode_sep(''),
                    \ join(a:flags, ''),
                    \ crystalline#right_sep('', 'Fill'),
                    \ a:fname
                    \ )
    endif
endfunction

" ZoomWin Integration
let s:ZoomWin_funcref = []

if exists('g:ZoomWin_funcref')
    if type(g:ZoomWin_funcref) == 2
        let s:ZoomWin_funcref = [g:ZoomWin_funcref]
    elseif type(g:ZoomWin_funcref) == 3
        let s:ZoomWin_funcref = g:ZoomWin_funcref
    endif
endif

function! ZoomWinStatusLine(zoomstate) abort
    for f in s:ZoomWin_funcref
        if type(f) == 2
            call f(a:zoomstate)
        endif
    endfor
endfunction

let g:ZoomWin_funcref= function('ZoomWinStatusLine')
