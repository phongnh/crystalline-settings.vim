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
    let g:crystalline_show_devicons   = get(g:, 'crystalline_show_devicons', 0)
    let g:crystalline_show_vim_logo   = get(g:, 'crystalline_show_vim_logo', 1)

    " Theme mappings
    let g:crystalline_theme_mappings = extend({
                \ '^\(solarized\|soluarized\|flattened\)': 'solarized8',
                \ '^gruvbox': 'gruvbox',
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

    let g:crystalline_show_devicons = g:crystalline_show_devicons && crystalline_settings#devicons#Detect()

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
                   \ 'bomb':  "\ue287 ",
                   \ 'noeol': "\ue293 ",
                   \ 'dos':   "\ue70f",
                   \ 'mac':   "\ue711",
                   \ 'unix':  "\ue712",
                   \ })
        let g:crystalline_symbols.unix = '[unix]'
    endif

    let g:crystalline_vimlabel = has('nvim') ? ' NVIM ' : ' VIM '
    if g:crystalline_show_devicons && g:crystalline_show_vim_logo
        " Show Vim Logo in Tabline
        let g:crystalline_vimlabel = " \ue7c5  "
    endif
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
