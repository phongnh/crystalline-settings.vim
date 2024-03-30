function! crystalline_settings#Trim(str) abort
    return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

if exists('*trim')
    function! crystalline_settings#Trim(str) abort
        return trim(a:str)
    endfunction
endif

function! crystalline_settings#ShortenPath(filename) abort
    return substitute(a:filename, '\v\w\zs.{-}\ze(\\|/)', '', 'g')
endfunction

if exists('*pathshorten')
    function! crystalline_settings#ShortenPath(filename) abort
        return pathshorten(a:filename)
    endfunction
endif

function! crystalline_settings#FormatFileName(fname, winwidth, max_width) abort
    let fname = a:fname

    if a:winwidth < g:crystalline_winwidth_config.default
        return fnamemodify(fname, ':t')
    endif

    if strlen(fname) > a:winwidth && (fname[0] =~ '\~\|/') && g:crystalline_shorten_path
        let fname = crystalline_settings#ShortenPath(fname)
    endif

    let max_width = min([a:winwidth, a:max_width])

    if strlen(fname) > max_width
        let fname = fnamemodify(fname, ':t')
    endif

    return fname
endfunction

function! crystalline_settings#Group(exp) abort
    if a:exp =~ '^%'
        return '%( ' . a:exp . ' %)'
    else
        return '%( %{' . a:exp . '} %)'
    endif
endfunction

function! crystalline_settings#Concatenate(parts, ...) abort
    let separator = get(a:, 1, 0) ? g:crystalline_symbols.right_sep : g:crystalline_symbols.left_sep
    return join(filter(copy(a:parts), 'v:val !=# ""'), ' ' . separator . ' ')
endfunction

function! crystalline_settings#Setup() abort
    " Disable NERDTree statusline
    let g:NERDTreeStatusline = -1

    " Crystalline Settings
    let g:crystalline_enable_sep      = 1
    let g:crystalline_powerline_fonts = get(g:, 'crystalline_powerline_fonts', 0)
    let g:crystalline_shorten_path    = get(g:, 'crystalline_shorten_path', 0)
    let g:crystalline_show_short_mode = get(g:, 'crystalline_show_short_mode', 0)
    let g:crystalline_show_git_branch = get(g:, 'crystalline_show_git_branch', 0)
    let g:crystalline_show_linenr     = get(g:, 'crystalline_show_linenr', 0)
    let g:crystalline_show_devicons   = get(g:, 'crystalline_show_devicons', 0) && crystalline_settings#devicons#Detect()

    " Theme mappings
    let g:crystalline_theme_mappings = extend({
                \ '^\(solarized\|soluarized\|flattened\|neosolarized\)': 'solarized8',
                \ '^gruvbox': 'gruvbox',
                \ '^habamax$': 'onehalfdark',
                \ '^retrobox$': 'gruvbox',
                \  }, get(g:, 'crystalline_theme_mappings', {}))

    " Improved Model Labels
    let g:crystalline_mode_labels = {
                \ 'n':  ' NORMAL ',
                \ 'c':  ' COMMAND ',
                \ 'r':  ' NORMAL ',
                \ '!':  ' NORMAL ',
                \ 'i':  ' INSERT ',
                \ 't':  ' TERMINAL ',
                \ 'v':  ' VISUAL ',
                \ 'V':  ' V-LINE ',
                \ '': ' V-BLOCK ',
                \ 's':  ' SELECT ',
                \ 'S':  ' S-LINE ',
                \ '': ' S-BLOCK ',
                \ 'R':  ' REPLACE ',
                \ '':   '',
                \ }

    let g:crystalline_short_mode_labels = {
                \ 'n':  ' N ',
                \ 'c':  ' C ',
                \ 'r':  ' N ',
                \ '!':  ' N ',
                \ 'i':  ' I ',
                \ 't':  ' T ',
                \ 'v':  ' V ',
                \ 'V':  ' L ',
                \ '': ' B ',
                \ 's':  ' S ',
                \ 'S':  ' S-L ',
                \ '': ' S-B ',
                \ 'R':  ' R ',
                \ '':   '',
                \ }

    if g:crystalline_show_short_mode
        let g:crystalline_mode_labels = copy(g:crystalline_short_mode_labels)
    endif

    " Window width
    let g:crystalline_winwidth_config = extend({
                \ 'compact': 60,
                \ 'default': 90,
                \ 'normal':  120,
                \ }, get(g:, 'crystalline_winwidth_config', {}))

    " Symbols: https://en.wikipedia.org/wiki/Enclosed_Alphanumerics
    let g:crystalline_symbols = {
                \ 'logo':      '',
                \ 'dos':       '[dos]',
                \ 'mac':       '[mac]',
                \ 'unix':      '[unix]',
                \ 'linenr':    '☰',
                \ 'branch':    '⎇ ',
                \ 'readonly':  '',
                \ 'bomb':      '🅑 ',
                \ 'noeol':     '∉ ',
                \ 'clipboard': '🅒 ',
                \ 'paste':     '🅟 ',
                \ 'ellipsis':  '…',
                \ }

    if g:crystalline_powerline_fonts || g:crystalline_show_devicons
        call extend(g:crystalline_symbols, {
                    \ 'linenr':   "\ue0a1",
                    \ 'branch':   "\ue0a0",
                    \ 'readonly': "\ue0a2",
                    \ })
        call crystalline_settings#powerline#SetSeparators(get(g:, 'crystalline_powerline_style', 'default'))
    else
        let g:crystalline_separators = [
                    \ { 'ch': '', 'alt_ch': '|', 'dir': '>' },
                    \ { 'ch': '', 'alt_ch': '|', 'dir': '<' },
                    \ ]
        let g:crystalline_symbols = extend(g:crystalline_symbols, {
                    \ 'left':      '',
                    \ 'right':     '',
                    \ 'left_sep':  '|',
                    \ 'right_sep': '|',
                    \ })
    endif

    if g:crystalline_show_devicons
        call extend(g:crystalline_symbols, {
                    \ 'logo':  " \ue7c5  ",
                    \ 'bomb':  "\ue287 ",
                    \ 'noeol': "\ue293 ",
                    \ 'dos':   "\ue70f",
                    \ 'mac':   "\ue711",
                    \ 'unix':  "\ue712",
                    \ })
        let g:crystalline_symbols.unix = '[unix]'
    endif

    " Alternate status dictionaries
    let g:crystalline_filename_modes = {
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

    let g:crystalline_filetype_modes = {
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
                \ 'SpaceVimFlyGrep':   'FlyGrep',
                \ }

    let g:crystalline_filename_integrations = {
                \ 'ControlP':          'crystalline_settings#ctrlp#Mode',
                \ '__CtrlSF__':        'crystalline_settings#ctrlsf#Mode',
                \ '__CtrlSFPreview__': 'crystalline_settings#ctrlsf#PreviewMode',
                \ '__flygrep__':       'crystalline_settings#flygrep#Mode',
                \ '__Tagbar__':        'crystalline_settings#tagbar#Mode',
                \ }

    let g:crystalline_filetype_integrations = {
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
                \ 'SpaceVimFlyGrep': 'crystalline_settings#flygrep#Mode',
                \ }

endfunction

function! crystalline_settings#Init() abort
    setglobal noshowmode

    call crystalline_settings#parts#Init()
    call crystalline_settings#theme#Init()

    " CtrlP Integration
    if exists(':CtrlP') == 2
        let g:ctrlp_status_func = {
                    \ 'main': 'crystalline_settings#ctrlp#MainStatus',
                    \ 'prog': 'crystalline_settings#ctrlp#ProgressStatus',
                    \ }
    endif

    " Tagbar Integration
    if exists(':Tagbar') == 2
        let g:tagbar_status_func = 'crystalline_settings#tagbar#Status'
    endif

    " ZoomWin Integration
    if exists(':ZoomWin') == 2
        let g:crystalline_zoomwin_funcref = []

        if exists('g:ZoomWin_funcref')
            if type(g:ZoomWin_funcref) == v:t_func
                let g:crystalline_zoomwin_funcref = [g:ZoomWin_funcref]
            elseif type(g:ZoomWin_funcref) == v:t_func
                let g:crystalline_zoomwin_funcref = g:ZoomWin_funcref
            endif
            let g:crystalline_zoomwin_funcref = uniq(copy(g:crystalline_zoomwin_funcref))
        endif

        let g:ZoomWin_funcref = function('crystalline_settings#zoomwin#Status')
    endif
endfunction
