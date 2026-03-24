" Alternate status dictionaries
let s:crystalline_filename_modes = {
            \ 'ControlP':             'CtrlP',
            \ '__CtrlSF__':           'CtrlSF',
            \ '__CtrlSFPreview__':    'Preview',
            \ '__flygrep__':          'FlyGrep',
            \ '__Tagbar__':           'Tagbar',
            \ '__Gundo__':            'Gundo',
            \ '__Gundo_Preview__':    'Gundo Preview',
            \ '__Mundo__':            'Mundo',
            \ '__Mundo_Preview__':    'Mundo Preview',
            \ '[BufExplorer]':        'BufExplorer',
            \ '[Command Line]':       'Command Line',
            \ '[Plugins]':            'Plugins',
            \ '__committia_status__': 'Git Status',
            \ '__committia_diff__':   'Git Diff',
            \ '__doc__':              'Document',
            \ '__LSP_SETTINGS__':     'LSP Settings',
            \ }

let s:crystalline_filetype_modes = {
            \ 'bufexplorer':       'BufExplorer',
            \ 'simplebuffer':      'SimpleBuffer',
            \ 'netrw':             'Netrw',
            \ 'molder':            'Molder',
            \ 'dirvish':           'Dirvish',
            \ 'vaffle':            'Vaffle',
            \ 'nerdtree':          'NERDTree',
            \ 'fern':              'Fern',
            \ 'neo-tree':          'NeoTree',
            \ 'carbon.explorer':   'Carbon',
            \ 'oil':               'Oil',
            \ 'NvimTree':          'NvimTree',
            \ 'CHADTree':          'CHADTree',
            \ 'LuaTree':           'LuaTree',
            \ 'Mundo':             'Mundo',
            \ 'MundoDiff':         'Mundo Preview',
            \ 'undotree':          'Undo',
            \ 'diff':              'Diff',
            \ 'gundo':             'Gundo',
            \ 'startify':          'Startify',
            \ 'alpha':             'Alpha',
            \ 'dashboard':         'Dashboard',
            \ 'ministarter':       'Starter',
            \ 'tagbar':            'Tagbar',
            \ 'vista':             'Vista',
            \ 'vista_kind':        'Vista',
            \ 'vim-plug':          'Plugins',
            \ 'terminal':          'TERMINAL',
            \ 'help':              'HELP',
            \ 'qf':                'Quickfix',
            \ 'godoc':             'GoDoc',
            \ 'gedoc':             'GeDoc',
            \ 'gitcommit':         'Commit Message',
            \ 'gitrebase':         'Git Rebase',
            \ 'fugitive':          'Git Status',
            \ 'fugitiveblame':     'FugitiveBlame',
            \ 'gitmessengerpopup': 'Git Messenger',
            \ 'GV':                'GV',
            \ 'agit':              'Agit',
            \ 'agit_diff':         'Git Diff',
            \ 'agit_stat':         'Git Stat',
            \ 'GrepperSide':       'GrepperSide',
            \ 'SpaceVimFlyGrep':   'FlyGrep',
            \ 'startuptime':       'StartupTime',
            \ }

let s:crystalline_filename_integrations = {
            \ 'ControlP':          'crystalline_settings#ctrlp#Mode',
            \ '__CtrlSF__':        'crystalline_settings#ctrlsf#Mode',
            \ '__CtrlSFPreview__': 'crystalline_settings#ctrlsf#PreviewMode',
            \ '__flygrep__':       'crystalline_settings#flygrep#Mode',
            \ '__Tagbar__':        'crystalline_settings#tagbar#Mode',
            \ }

let s:crystalline_filetype_integrations = {
            \ 'cmdline':         'crystalline_settings#cmdline#Mode',
            \ 'ctrlp':           'crystalline_settings#ctrlp#Mode',
            \ 'nerdtree':        'crystalline_settings#nerdtree#Mode',
            \ 'netrw':           'crystalline_settings#netrw#Mode',
            \ 'dirvish':         'crystalline_settings#dirvish#Mode',
            \ 'molder':          'crystalline_settings#molder#Mode',
            \ 'vaffle':          'crystalline_settings#vaffle#Mode',
            \ 'fern':            'crystalline_settings#fern#Mode',
            \ 'carbon.explorer': 'crystalline_settings#carbon#Mode',
            \ 'neo-tree':        'crystalline_settings#neotree#Mode',
            \ 'oil':             'crystalline_settings#oil#Mode',
            \ 'undotree':        'crystalline_settings#undotree#Mode',
            \ 'diff':            'crystalline_settings#diff#Mode',
            \ 'tagbar':          'crystalline_settings#tagbar#Mode',
            \ 'vista_kind':      'crystalline_settings#vista#Mode',
            \ 'vista':           'crystalline_settings#vista#Mode',
            \ 'NrrwRgn':         'crystalline_settings#nrrwrgn#Mode',
            \ 'git':             'crystalline_settings#git#Mode',
            \ 'gitcommit':       'crystalline_settings#gitcommit#Mode',
            \ 'gitrebase':       'crystalline_settings#gitrebase#Mode',
            \ 'fugitive':        'crystalline_settings#fugitive#Mode',
            \ 'GV':              'crystalline_settings#gv#Mode',
            \ 'terminal':        'crystalline_settings#terminal#Mode',
            \ 'help':            'crystalline_settings#help#Mode',
            \ 'qf':              'crystalline_settings#quickfix#Mode',
            \ 'ctrlsf':          'crystalline_settings#ctrlsf#Mode',
            \ 'GrepperSide':     'crystalline_settings#grepper#Mode',
            \ 'SpaceVimFlyGrep': 'crystalline_settings#flygrep#Mode',
            \ }

function! s:BufferType() abort
    return !empty(&filetype) ? &filetype : &buftype
endfunction

function! s:FileName() abort
    let l:fname = expand('%')
    return !empty(l:fname) ? fnamemodify(l:fname, ':~:.') : '[No Name]'
endfunction

function! s:IsClipboardEnabled() abort
    return stridx(&clipboard, 'unnamed') > -1
endfunction

function! s:IsCompact(...) abort
    let l:winnr = get(a:, 1, 0)
    return crystalline_settings#GetWinWidth(l:winnr) <= g:crystalline_winwidth_config.compact ||
                \ count([
                \   s:IsClipboardEnabled(),
                \   &paste,
                \   &spell,
                \   &bomb,
                \   !&eol,
                \ ], 1) > 1
endfunction

function! crystalline_settings#parts#Mode() abort
    if s:IsCompact()
        return crystalline_settings#Trim(get(g:crystalline_short_mode_labels, mode(), ''))
    else
        return crystalline_settings#Trim(crystalline#ModeLabel())
    endif
endfunction

function! crystalline_settings#parts#Clipboard() abort
    return s:IsClipboardEnabled() ? g:crystalline_symbols.clipboard : ''
endfunction

function! crystalline_settings#parts#Paste() abort
    return &paste ? g:crystalline_symbols.paste : ''
endfunction

function! crystalline_settings#parts#Spell() abort
    return &spell ? toupper(tr(&spelllang, ',', '/')) : ''
endfunction

function! s:Shiftwidth() abort
    return exists('*shiftwidth') ? shiftwidth() : &shiftwidth
endfunction

function! crystalline_settings#parts#Indentation(...) abort
    let l:compact = get(a:, 1, s:IsCompact())
    if &expandtab
        return (l:compact ? 'SPC' : 'Spaces') .. ': ' .. s:Shiftwidth()
    else
        return (l:compact ? 'TAB' : 'Tab Size') .. ': ' .. &tabstop
    endif
endfunction

function! s:ReadonlyStatus(...) abort
    return &readonly ? g:crystalline_symbols.readonly .. ' ' : ''
endfunction

function! s:ModifiedStatus(...) abort
    if &modified
        return !&modifiable ? '[+-]' : '[+]'
    else
        return !&modifiable ? '[-]' : ''
    endif
endfunction

function! s:ZoomedStatus(...) abort
    return get(g:, 'crystalline_zoomstate', 0) ? '[Z]' : ''
endfunction

function! crystalline_settings#parts#LineInfo(...) abort
    return ''
endfunction

if g:crystalline_show_linenr > 1
    function! crystalline_settings#parts#LineInfo(...) abort
        return call('crystalline_settings#lineinfo#Full', a:000)
    endfunction
elseif g:crystalline_show_linenr > 0
    function! crystalline_settings#parts#LineInfo(...) abort
        return call('crystalline_settings#lineinfo#Simple', a:000)
    endfunction
endif

function! crystalline_settings#parts#FileEncodingAndFormat() abort
    " Skip encoding check if it's utf-8 and format is unix (common case)
    if &fileencoding ==# 'utf-8' && &fileformat ==# 'unix' && !&bomb && &eol
        return ''
    endif

    let l:parts = []

    let l:encoding = !empty(&fileencoding) ? &fileencoding : &encoding
    if !empty(l:encoding) && l:encoding !=# 'utf-8'
        call add(l:parts, l:encoding)
    endif

    if &bomb | call add(l:parts, g:crystalline_symbols.bomb) | endif
    if !&eol | call add(l:parts, g:crystalline_symbols.noeol) | endif

    if !empty(&fileformat) && &fileformat !=# 'unix'
        call add(l:parts, get(g:crystalline_symbols, &fileformat, &fileformat))
    endif

    return join(l:parts, ' ')
endfunction

function! crystalline_settings#parts#FileType(...) abort
    return s:BufferType() .. crystalline_settings#devicons#FileType(expand('%'))
endfunction

function! crystalline_settings#parts#FileName(...) abort
    let l:winwidth = crystalline_settings#GetWinWidth(get(a:, 1, 0))
    return s:ReadonlyStatus() .. crystalline_settings#FormatFileName(s:FileName(), l:winwidth, 50) .. s:ZoomedStatus() .. s:ModifiedStatus()
endfunction

function! crystalline_settings#parts#InactiveFileName(...) abort
    return s:ReadonlyStatus() .. s:FileName() .. s:ModifiedStatus()
endfunction

function! crystalline_settings#parts#Integration() abort
    let l:ft = s:BufferType()

    if has_key(s:crystalline_filetype_integrations, l:ft)
        return function(s:crystalline_filetype_integrations[l:ft])()
    endif

    let l:fname = expand('%:t')

    if has_key(s:crystalline_filename_integrations, l:fname)
        return function(s:crystalline_filename_integrations[l:fname])()
    elseif l:fname =~# '^NrrwRgn_\zs.*\ze_\d\+$'
        " Fallback to filename check if NrrwRgn buffer's filetype is not set
        return crystalline_settings#nrrwrgn#Mode()
    endif

    if has_key(s:crystalline_filetype_modes, l:ft)
        return { 'section_a': s:crystalline_filetype_modes[l:ft] }
    endif

    if has_key(s:crystalline_filename_modes, l:fname)
        return { 'section_a': s:crystalline_filename_modes[l:fname] }
    endif

    return {}
endfunction

function! crystalline_settings#parts#GitBranch(...) abort
    return ''
endfunction

if g:crystalline_show_git_branch > 0
    function! crystalline_settings#parts#GitBranch(...) abort
        return call('crystalline_settings#gitbranch#Name', a:000)
    endfunction
endif
