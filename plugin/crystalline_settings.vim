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

function! s:CrystallinePasteAndSpell() abort
    let ary = []

    if &paste
        call add(ary, '[PASTE]')
    endif

    if &spell
        call add(ary, '[SPELL]')
    endif

    if len(ary)
        return ' ' . join(ary, ' ') . ' '
    endif

    return ''
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
    return printf('%%#CrystallineNormalMode# %s ', new_mode)
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
        let l:s .= '%#CrystallineInactive#'
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
    return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab#' . l:vimlabel
endfunction

let g:crystalline_enable_sep    = get(g:, 'crystalline_powerline', 0)
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn    = 'TabLine'
let g:crystalline_theme         = 'solarized'
