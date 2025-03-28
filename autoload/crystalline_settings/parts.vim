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

function! s:BufferType() abort
    return strlen(&filetype) ? &filetype : &buftype
endfunction

function! s:FileName() abort
    let fname = expand('%')
    return strlen(fname) ? fnamemodify(fname, ':~:.') : '[No Name]'
endfunction

function! s:IsClipboardEnabled() abort
    return match(&clipboard, 'unnamed') > -1
endfunction

function! s:IsCompact(...) abort
    let l:winnr = get(a:, 1, 0)
    return winwidth(l:winnr) <= g:crystalline_winwidth_config.compact ||
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
    let compact = get(a:, 1, s:IsCompact())
    if compact
        return printf(&expandtab ? 'SPC: %d' : 'TAB: %d', l:shiftwidth)
    else
        return printf(&expandtab ? 'Spaces: %d' : 'Tab Size: %d', l:shiftwidth)
    endif
endfunction

function! s:ReadonlyStatus(...) abort
    return &readonly ? g:crystalline_symbols.readonly . ' ' : ''
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
    let l:encoding = strlen(&fileencoding) ? &fileencoding : &encoding
    let l:encoding = (l:encoding ==# 'utf-8') ? '' : l:encoding . ' '
    let l:bomb     = &bomb ? g:crystalline_symbols.bomb . ' ' : ''
    let l:noeol    = &eol ? '' : g:crystalline_symbols.noeol . ' '
    let l:format   = get(g:crystalline_symbols, &fileformat, '[empty]')
    let l:format   = (l:format ==# '[unix]') ? '' : l:format . ' '
    return l:encoding . l:bomb . l:noeol . l:format
endfunction

function! crystalline_settings#parts#FileType(...) abort
    return s:BufferType() . crystalline_settings#devicons#FileType(expand('%'))
endfunction

function! crystalline_settings#parts#FileName(...) abort
    let winwidth = get(a:, 1, 100)
    return s:ReadonlyStatus() . crystalline_settings#FormatFileName(s:FileName(), winwidth, 50) . s:ModifiedStatus() . s:ZoomedStatus()
endfunction

function! crystalline_settings#parts#InactiveFileName(...) abort
    return s:ReadonlyStatus() . s:FileName() . s:ModifiedStatus()
endfunction

function! crystalline_settings#parts#Integration() abort
    let fname = expand('%:t')

    if has_key(s:crystalline_filename_modes, fname)
        let result = { 'name': s:crystalline_filename_modes[fname] }

        if has_key(s:crystalline_filename_integrations, fname)
            return extend(result, function(s:crystalline_filename_integrations[fname])())
        endif

        return result
    endif

    if fname =~# '^NrrwRgn_\zs.*\ze_\d\+$'
        return crystalline_settings#nrrwrgn#Mode()
    endif

    let ft = s:BufferType()

    if ft ==# 'undotree' && exists('*t:undotree.GetStatusLine')
        return crystalline_settings#undotree#Mode()
    endif

    if ft ==# 'diff' && exists('*t:diffpanel.GetStatusLine')
        return crystalline_settings#undotree#DiffStatus()
    endif

    if has_key(s:crystalline_filetype_modes, ft)
        let result = { 'name': s:crystalline_filetype_modes[ft] }

        if has_key(s:crystalline_filetype_integrations, ft)
            return extend(result, function(s:crystalline_filetype_integrations[ft])())
        endif

        return result
    endif

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
