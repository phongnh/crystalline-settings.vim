if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    finish
endif
let g:loaded_vim_crystalline_settings = 1

let s:save_cpo = &cpo
set cpo&vim

let s:filename_modes = {
            \ 'ControlP':             'CtrlP',
            \ '__Tagbar__':           'Tagbar',
            \ '__Gundo__':            'Gundo',
            \ '__Gundo_Preview__':    'Gundo Preview',
            \ '[BufExplorer]':        'BufExplorer',
            \ 'NERD_tree':            'NERDTree',
            \ 'NERD_tree_1':          'NERDTree',
            \ '[Command Line]':       'Command Line',
            \ '[Plugins]':            'Plugins',
            \ '__committia_status__': 'Committia Status',
            \ '__committia_diff__':   'Committia Diff',
            \ }

let s:filetype_modes = {
            \ 'netrw':         'NetrwTree',
            \ 'nerdtree':      'NERDTree',
            \ 'startify':      'Startify',
            \ 'vim-plug':      'Plug',
            \ 'unite':         'Unite',
            \ 'vimfiler':      'VimFiler',
            \ 'vimshell':      'VimShell',
            \ 'help':          'Help',
            \ 'qf':            'Quickfix',
            \ 'godoc':         'GoDoc',
            \ 'gedoc':         'GeDoc',
            \ 'gitcommit':     'Commit Message',
            \ 'fugitiveblame': 'FugitiveBlame',
            \ 'agit':          'Agit',
            \ 'agit_diff':     'Agit',
            \ 'agit_stat':     'Agit',
            \ }

let s:short_modes = {
            \ 'NORMAL':   'N',
            \ 'INSERT':   'I',
            \ 'VISUAL':   'V',
            \ 'V-LINE':   'L',
            \ 'V-BLOCK':  'B',
            \ 'COMMAND':  'C',
            \ 'SELECT':   'S',
            \ 'S-LINE':   'S-L',
            \ 'S-BLOCK':  'S-B',
            \ 'TERMINAL': 'T',
            \ }

function! CrystallinePasteAndSpell() abort
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

function! CrystallineFileEncoding() abort
    let encoding = &fenc !=# '' ? &fenc : &enc
    if encoding !=? 'utf-8'
        return '[' . encoding . ']'
    endif
    return ''
endfunction

function! CrystallineFileFormat() abort
    return &ff !=? 'unix' ? '[' . &ff . ']' : ''
endfunction

function! CrystallineSpacesOrTabSize() abort
    let shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    return printf(' %s: %d ', (&expandtab ? 'Spaces' : 'Tab Size'), shiftwidth)
endfunction

function! CrystallineCustomMode() abort
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

function! s:CustomizeBranch(branch) abort
    if strlen(a:branch) > 51
        return split(a:branch, '/')[-1]
    endif
    return a:branch
endfunction

function! CrystallineBranch() abort
    if exists('*fugitive#head')
        return s:CustomizeBranch(fugitive#head())
    elseif exists(':Gina') == 2
        return s:CustomizeBranch(gina#component#repo#branch())
    else
        return fnamemodify(getcwd(), ':t')
    endif
endfunction

function! StatusLine(current, width)
    let l:s = ''

    if a:current && s:IsCustomMode()
        let l:s .= CrystallineCustomMode() . crystalline#right_mode_sep('')
        return l:s
    endif

    if a:current
        let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
    else
        let l:s .= '%#CrystallineInactive#'
    endif
    let l:s .= ' %f%h%w%m%r '

    if a:current
        let l:s .= crystalline#right_sep('', 'Fill') . ' %{CrystallineBranch()}'
    endif

    let l:s .= '%='
    if a:current
        let l:s .= CrystallinePasteAndSpell()
        let l:s .= crystalline#left_sep('', 'Fill')
        let l:s .= CrystallineSpacesOrTabSize()
        let l:s .= crystalline#left_mode_sep('')
    endif

    if a:width > 80
        let l:s .= ' %{&ft}%{CrystallineFileEncoding()}%{CrystallineFileFormat()} '
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
