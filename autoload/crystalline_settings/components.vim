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
            \ 'vim-plug':          'Plugins',
            \ 'terminal':          'TERMINAL',
            \ 'help':              'HELP',
            \ 'man':               'MAN',
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
            \ 'ControlP':          'crystalline_settings#ctrlp#Statusline',
            \ '__CtrlSF__':        'crystalline_settings#ctrlsf#Statusline',
            \ '__CtrlSFPreview__': 'crystalline_settings#ctrlsf#PreviewMode',
            \ '__flygrep__':       'crystalline_settings#flygrep#Statusline',
            \ '__Tagbar__':        'crystalline_settings#tagbar#Statusline',
            \ }

let s:crystalline_filetype_integrations = {
            \ 'cmdline':         'crystalline_settings#cmdline#Statusline',
            \ 'ctrlp':           'crystalline_settings#ctrlp#Statusline',
            \ 'nerdtree':        'crystalline_settings#nerdtree#Statusline',
            \ 'netrw':           'crystalline_settings#netrw#Statusline',
            \ 'dirvish':         'crystalline_settings#dirvish#Statusline',
            \ 'molder':          'crystalline_settings#molder#Statusline',
            \ 'vaffle':          'crystalline_settings#vaffle#Statusline',
            \ 'fern':            'crystalline_settings#fern#Statusline',
            \ 'carbon.explorer': 'crystalline_settings#carbon#Statusline',
            \ 'neo-tree':        'crystalline_settings#neotree#Statusline',
            \ 'oil':             'crystalline_settings#oil#Statusline',
            \ 'undotree':        'crystalline_settings#undotree#Statusline',
            \ 'diff':            'crystalline_settings#diff#Statusline',
            \ 'tagbar':          'crystalline_settings#tagbar#Statusline',
            \ 'NrrwRgn':         'crystalline_settings#nrrwrgn#Statusline',
            \ 'git':             'crystalline_settings#git#Statusline',
            \ 'gitcommit':       'crystalline_settings#gitcommit#Statusline',
            \ 'gitrebase':       'crystalline_settings#gitrebase#Statusline',
            \ 'fugitive':        'crystalline_settings#fugitive#Statusline',
            \ 'GV':              'crystalline_settings#gv#Statusline',
            \ 'terminal':        'crystalline_settings#terminal#Statusline',
            \ 'help':            'crystalline_settings#help#Statusline',
            \ 'man':             'crystalline_settings#man#Statusline',
            \ 'qf':              'crystalline_settings#quickfix#Statusline',
            \ 'ctrlsf':          'crystalline_settings#ctrlsf#Statusline',
            \ 'GrepperSide':     'crystalline_settings#grepper#Statusline',
            \ 'SpaceVimFlyGrep': 'crystalline_settings#flygrep#Statusline',
            \ }

let s:spelllang_maps = { 'en_us': 'US', 'en_gb': 'GB' }

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

function! crystalline_settings#components#Mode() abort
    if s:IsCompact()
        return crystalline_settings#Trim(get(g:crystalline_short_mode_labels, mode(), ''))
    else
        return crystalline_settings#Trim(crystalline#ModeLabel())
    endif
endfunction

function! crystalline_settings#components#Clipboard() abort
    return s:IsClipboardEnabled() ? g:crystalline_symbols.clipboard : ''
endfunction

function! crystalline_settings#components#Paste() abort
    return &paste ? g:crystalline_symbols.paste : ''
endfunction

function! crystalline_settings#components#Spell() abort
    return &spell ? split(&spelllang, ',')->map('get(s:spelllang_maps, v:val, toupper(v:val))')->join('/') : ''
endfunction

function! s:Shiftwidth() abort
    return exists('*shiftwidth') ? shiftwidth() : &shiftwidth
endfunction

function! crystalline_settings#components#Indentation(...) abort
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

function! crystalline_settings#components#Progress(...) abort
    if line('w0') == 1 && line('w$') == line('$')
        return 'All'
    elseif line('w0') == 1
        return 'Top'
    elseif line('w$') == line('$')
        return 'Bot'
    else
        return (line('.') * 100 / line('$')) .. '%'
    endif
endfunction

function! crystalline_settings#components#Position(...) abort
    return printf('%4d:%-3d', line('.'), charcol('.'))
endfunction

function! crystalline_settings#components#Ruler(...) abort
    return printf('%4d:%-3d %3s', line('.'), charcol('.'), crystalline_settings#components#Progress())
endfunction

function! crystalline_settings#components#FileEncodingAndFormat() abort
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

function! crystalline_settings#components#FileType(...) abort
    return s:BufferType() .. crystalline_settings#devicons#FileType(expand('%'))
endfunction

function! crystalline_settings#components#FileName(...) abort
    let l:winwidth = crystalline_settings#GetWinWidth(get(a:, 1, 0))
    return s:ReadonlyStatus() .. crystalline_settings#FormatFileName(s:FileName(), l:winwidth, 50) .. s:ZoomedStatus() .. s:ModifiedStatus()
endfunction

function! crystalline_settings#components#InactiveFileName(...) abort
    return s:ReadonlyStatus() .. s:FileName() .. s:ModifiedStatus()
endfunction

function! crystalline_settings#components#Integration() abort
    let l:ft = s:BufferType()

    if has_key(s:crystalline_filetype_integrations, l:ft)
        return function(s:crystalline_filetype_integrations[l:ft])()
    endif

    let l:fname = expand('%:t')

    if has_key(s:crystalline_filename_integrations, l:fname)
        return function(s:crystalline_filename_integrations[l:fname])()
    elseif l:fname =~# '^NrrwRgn_\zs.*\ze_\d\+$'
        " Fallback to filename check if NrrwRgn buffer's filetype is not set
        return crystalline_settings#nrrwrgn#Statusline()
    endif

    if has_key(s:crystalline_filetype_modes, l:ft)
        return { 'section_a': s:crystalline_filetype_modes[l:ft] }
    endif

    if has_key(s:crystalline_filename_modes, l:fname)
        return { 'section_a': s:crystalline_filename_modes[l:fname] }
    endif

    return {}
endfunction

function! crystalline_settings#components#Branch(...) abort
    return crystalline_settings#gitbranch#Component()
endfunction
