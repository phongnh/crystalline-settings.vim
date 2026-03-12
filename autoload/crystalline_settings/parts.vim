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
            \ '__committia_status__': 'Committia Status',
            \ '__committia_diff__':   'Committia Diff',
            \ '__doc__':              'Document',
            \ '__LSP_SETTINGS__':     'LSP Settings',
            \ }

let s:crystalline_filetype_modes = {
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
            \ 'fugitive':          'Fugitive',
            \ 'fugitiveblame':     'FugitiveBlame',
            \ 'gitmessengerpopup': 'Git Messenger',
            \ 'GV':                'GV',
            \ 'agit':              'Agit',
            \ 'agit_diff':         'Agit Diff',
            \ 'agit_stat':         'Agit Stat',
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
            \ 'ctrlp':           'crystalline_settings#ctrlp#Mode',
            \ 'netrw':           'crystalline_settings#netrw#Mode',
            \ 'dirvish':         'crystalline_settings#dirvish#Mode',
            \ 'molder':          'crystalline_settings#molder#Mode',
            \ 'vaffle':          'crystalline_settings#vaffle#Mode',
            \ 'fern':            'crystalline_settings#fern#Mode',
            \ 'carbon.explorer': 'crystalline_settings#carbon#Mode',
            \ 'neo-tree':        'crystalline_settings#neotree#Mode',
            \ 'oil':             'crystalline_settings#oil#Mode',
            \ 'tagbar':          'crystalline_settings#tagbar#Mode',
            \ 'vista_kind':      'crystalline_settings#vista#Mode',
            \ 'vista':           'crystalline_settings#vista#Mode',
            \ 'terminal':        'crystalline_settings#terminal#Mode',
            \ 'help':            'crystalline_settings#help#Mode',
            \ 'qf':              'crystalline_settings#quickfix#Mode',
            \ 'gitcommit':       'crystalline_settings#gitcommit#Mode',
            \ 'fugitive':        'crystalline_settings#fugitive#Mode',
            \ 'GV':              'crystalline_settings#gv#Mode',
            \ 'GrepperSide':     'crystalline_settings#grepper#Mode',
            \ 'SpaceVimFlyGrep': 'crystalline_settings#flygrep#Mode',
            \ }

" Cache window width to avoid repeated winwidth() calls
let s:cached_winwidth = 0
let s:cached_winwidth_nr = 0

function! s:GetWinWidth(...) abort
    let l:winnr = get(a:, 1, 0)
    " Cache is only valid for current window in current update
    if l:winnr == s:cached_winwidth_nr && s:cached_winwidth > 0
        return s:cached_winwidth
    endif
    let s:cached_winwidth = winwidth(l:winnr)
    let s:cached_winwidth_nr = l:winnr
    return s:cached_winwidth
endfunction

" Expose for use in other modules
function! crystalline_settings#parts#GetWinWidth(...) abort
    return call('s:GetWinWidth', a:000)
endfunction

" Clear width cache
function! crystalline_settings#parts#ClearWidthCache() abort
    let s:cached_winwidth = 0
    let s:cached_winwidth_nr = 0
endfunction

" Cache for integration lookups - invalidated on buffer change
let s:integration_cache = {}
let s:integration_cache_bufnr = -1

" Clear integration cache
function! crystalline_settings#parts#ClearIntegrationCache() abort
    let s:integration_cache = {}
    let s:integration_cache_bufnr = -1
endfunction

function! s:BufferType() abort
    return strlen(&filetype) ? &filetype : &buftype
endfunction

function! s:FileName() abort
    let l:fname = expand('%')
    return strlen(l:fname) ? fnamemodify(l:fname, ':~:.') : '[No Name]'
endfunction

function! s:IsClipboardEnabled() abort
    return match(&clipboard, 'unnamed') > -1
endfunction

function! s:IsCompact(...) abort
    let l:winnr = get(a:, 1, 0)
    return s:GetWinWidth(l:winnr) <= g:crystalline_winwidth_config.compact ||
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
    return &spell ? toupper(substitute(&spelllang, ',', '/', 'g')) : ''
endfunction

function! crystalline_settings#parts#Indentation(...) abort
    let l:shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    let l:compact = get(a:, 1, s:IsCompact())
    if l:compact
        return printf(&expandtab ? 'SPC: %d' : 'TAB: %d', l:shiftwidth)
    else
        return printf(&expandtab ? 'Spaces: %d' : 'Tab Size: %d', l:shiftwidth)
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
    return get(g:, 'crystalline_zoomed', 0) ? '[Z]' : ''
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

    let l:encoding = strlen(&fileencoding) ? &fileencoding : &encoding
    let l:encoding = (l:encoding ==# 'utf-8') ? '' : l:encoding .. ' '
    let l:bomb     = &bomb ? g:crystalline_symbols.bomb .. ' ' : ''
    let l:noeol    = &eol ? '' : g:crystalline_symbols.noeol .. ' '
    let l:format   = get(g:crystalline_symbols, &fileformat, '[empty]')
    let l:format   = (l:format ==# '[unix]') ? '' : l:format .. ' '
    return l:encoding .. l:bomb .. l:noeol .. l:format
endfunction

function! crystalline_settings#parts#FileType(...) abort
    return s:BufferType() .. crystalline_settings#devicons#FileType(expand('%'))
endfunction

function! crystalline_settings#parts#FileName(...) abort
    let l:winwidth = get(a:, 1, 100)
    return s:ReadonlyStatus() .. crystalline_settings#FormatFileName(s:FileName(), l:winwidth, 50) .. s:ModifiedStatus() .. s:ZoomedStatus()
endfunction

function! crystalline_settings#parts#InactiveFileName(...) abort
    return s:ReadonlyStatus() .. s:FileName() .. s:ModifiedStatus()
endfunction

function! crystalline_settings#parts#Integration() abort
    " Return cached result if buffer hasn't changed
    let l:bufnr = bufnr('%')
    if s:integration_cache_bufnr == l:bufnr && !empty(s:integration_cache)
        return s:integration_cache
    endif

    " Update cache buffer number
    let s:integration_cache_bufnr = l:bufnr

    let l:fname = expand('%:t')

    if has_key(s:crystalline_filename_modes, l:fname)
        let l:result = { 'name': s:crystalline_filename_modes[l:fname] }

        if has_key(s:crystalline_filename_integrations, l:fname)
            let l:result = extend(l:result, function(s:crystalline_filename_integrations[l:fname])())
        endif

        let s:integration_cache = l:result
        return l:result
    endif

    if l:fname =~# '^NrrwRgn_\zs.*\ze_\d\+$'
        let s:integration_cache = crystalline_settings#nrrwrgn#Mode()
        return s:integration_cache
    endif

    let l:ft = s:BufferType()

    if l:ft ==# 'undotree' && exists('*t:undotree.GetStatusLine')
        let s:integration_cache = crystalline_settings#undotree#Mode()
        return s:integration_cache
    endif

    if l:ft ==# 'diff' && exists('*t:diffpanel.GetStatusLine')
        let s:integration_cache = crystalline_settings#undotree#DiffStatus()
        return s:integration_cache
    endif

    if has_key(s:crystalline_filetype_modes, l:ft)
        let l:result = { 'name': s:crystalline_filetype_modes[l:ft] }

        if has_key(s:crystalline_filetype_integrations, l:ft)
            let l:result = extend(l:result, function(s:crystalline_filetype_integrations[l:ft])())
        endif

        let s:integration_cache = l:result
        return l:result
    endif

    let s:integration_cache = {}
    return {}
endfunction

function! crystalline_settings#parts#GitBranch(...) abort
    return ''
endfunction

if g:crystalline_show_git_branch > 0
    function! crystalline_settings#parts#GitBranch(...) abort
        return call('crystalline_settings#git#Branch', a:000)
    endfunction
endif
