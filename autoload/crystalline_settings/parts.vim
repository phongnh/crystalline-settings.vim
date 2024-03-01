function! crystalline_settings#parts#Mode() abort
    if crystalline_settings#IsCompact()
        return crystalline_settings#Trim(get(g:crystalline_short_mode_labels, mode(), ''))
    else
        return crystalline_settings#Trim(crystalline#ModeLabel())
    endif
endfunction

function! crystalline_settings#parts#Clipboard() abort
    return crystalline_settings#IsClipboardEnabled() ? g:crystalline_symbols.clipboard : ''
endfunction

function! crystalline_settings#parts#Paste() abort
    return &paste ? g:crystalline_symbols.paste : ''
endfunction

function! crystalline_settings#parts#Spell() abort
    return &spell ? toupper(substitute(&spelllang, ',', '/', 'g')) : ''
endfunction

function! crystalline_settings#parts#Indentation(...) abort
    let l:shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    let compact = get(a:, 1, 0)
    if compact
        return printf(&expandtab ? 'SPC: %d' : 'TAB: %d', l:shiftwidth)
    else
        return printf(&expandtab ? 'Spaces: %d' : 'Tab Size: %d', l:shiftwidth)
    endif
endfunction

function! crystalline_settings#parts#Readonly(...) abort
    return &readonly ? g:crystalline_symbols.readonly . ' ' : ''
endfunction

function! crystalline_settings#parts#Modified(...) abort
    if &modified
        return !&modifiable ? '[+-]' : '[+]'
    else
        return !&modifiable ? '[-]' : ''
    endif
endfunction

function! crystalline_settings#parts#SimpleLineInfo(...) abort
    return printf('%3d:%-3d', line('.'), col('.'))
endfunction

function! crystalline_settings#parts#LineInfo(...) abort
    if line('w0') == 1 && line('w$') == line('$')
        let l:percent = 'All'
    elseif line('w0') == 1
        let l:percent = 'Top'
    elseif line('w$') == line('$')
        let l:percent = 'Bot'
    else
        let l:percent = printf('%d%%', line('.') * 100 / line('$'))
    endif

    return printf('%4d:%-3d %3s', line('.'), col('.'), l:percent)
endfunction

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
    return crystalline_settings#BufferType() . crystalline_settings#devicons#FileType(expand('%'))
endfunction

function! crystalline_settings#parts#FileInfo(...) abort
    return crystalline_settings#parts#FileType()
endfunction

function! crystalline_settings#parts#FileName(...) abort
    let winwidth = get(a:, 1, 100)
    return crystalline_settings#parts#Readonly() . crystalline_settings#FormatFileName(crystalline_settings#FileName(), winwidth, 50) . crystalline_settings#parts#Modified()
endfunction

function! crystalline_settings#parts#InactiveFileName(...) abort
    return crystalline_settings#parts#Readonly() . crystalline_settings#FileName() . crystalline_settings#parts#Modified()
endfunction

" Alternate status dictionaries
let g:crystalline_filename_modes = {
            \ 'ControlP':             'CtrlP',
            \ '__CtrlSF__':           'CtrlSF',
            \ '__CtrlSFPreview__':    'Preview',
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

let g:crystalline_filetype_modes = {
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
            \ 'startify':          'Startify',
            \ 'alpha':             'Alpha',
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
            \ 'fugitiveblame':     'FugitiveBlame',
            \ 'gitmessengerpopup': 'Git Messenger',
            \ 'GV':                'GV',
            \ 'agit':              'Agit',
            \ 'agit_diff':         'Agit Diff',
            \ 'agit_stat':         'Agit Stat',
            \ }

let g:crystalline_plugin_modes = {
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
            \ }

function! crystalline_settings#parts#Integration() abort
    let fname = expand('%:t')

    if has_key(g:crystalline_filename_modes, fname)
        let result = { 'name': g:crystalline_filename_modes[fname] }

        let l:plugin_modes = {
                    \ 'ControlP':          'crystalline_settings#ctrlp#Mode',
                    \ '__Tagbar__':        'crystalline_settings#tagbar#Mode',
                    \ '__CtrlSF__':        'crystalline_settings#ctrlsf#Mode',
                    \ '__CtrlSFPreview__': 'crystalline_settings#ctrlsf#PreviewMode',
                    \ }

        if has_key(l:plugin_modes, fname)
            return extend(result, function(l:plugin_modes[fname])())
        endif
    endif

    if fname =~# '^NrrwRgn_\zs.*\ze_\d\+$'
        return crystalline_settings#nrrwrgn#Mode()
    endif

    let ft = crystalline_settings#BufferType()
    if has_key(g:crystalline_filetype_modes, ft)
        let result = { 'name': g:crystalline_filetype_modes[ft] }

        if has_key(g:crystalline_plugin_modes, ft)
            return extend(result, function(g:crystalline_plugin_modes[ft])())
        endif

        return result
    endif

    return {}
endfunction
