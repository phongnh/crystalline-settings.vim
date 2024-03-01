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

    if a:winwidth < g:crystalline_winwidth_config.small
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

function! crystalline_settings#IsClipboardEnabled() abort
    return match(&clipboard, 'unnamed') > -1
endfunction

function! crystalline_settings#IsCompact(...) abort
    let l:winnr = get(a:, 1, 0)
    return winwidth(l:winnr) <= g:crystalline_winwidth_config.compact || count([crystalline_settings#IsClipboardEnabled(), &paste, &spell], 1) > 1
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

function! crystalline_settings#BufferType() abort
    return strlen(&filetype) ? &filetype : &buftype
endfunction

function! crystalline_settings#FileName() abort
    let fname = expand('%')
    return strlen(fname) ? fnamemodify(fname, ':~:.') : '[No Name]'
endfunction

function! crystalline_settings#Setup() abort
    " Disable NERDTree statusline
    let g:NERDTreeStatusline = -1

    " Crystalline Settings
    let g:crystalline_enable_sep      = 1
    let g:crystalline_powerline_fonts = get(g:, 'crystalline_powerline_fonts', 0)
    let g:crystalline_theme           = get(g:, 'crystalline_theme', 'solarized')
    let g:crystalline_shorten_path    = get(g:, 'crystalline_shorten_path', 0)
    let g:crystalline_show_short_mode = get(g:, 'crystalline_show_short_mode', 0)
    let g:crystalline_show_git_branch = get(g:, 'crystalline_show_git_branch', 1)
    let g:crystalline_show_devicons   = get(g:, 'crystalline_show_devicons', 1)
    let g:crystalline_show_vim_logo   = get(g:, 'crystalline_show_vim_logo', 1)

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
                \ 'small':   80,
                \ 'normal':  120,
                \ }, get(g:, 'crystalline_winwidth_config', {}))

    " Symbols: https://en.wikipedia.org/wiki/Enclosed_Alphanumerics
    let g:crystalline_symbols = {
                \ 'linenr':    '☰',
                \ 'branch':    '⎇ ',
                \ 'readonly':  '',
                \ 'clipboard': '🅒 ',
                \ 'paste':     '🅟 ',
                \ 'ellipsis':  '…',
                \ }

    if g:crystalline_powerline_fonts
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

    let g:crystalline_show_devicons = g:crystalline_show_devicons && crystalline_settings#devicons#Detect()

    let g:crystalline_vimlabel = has('nvim') ? ' NVIM ' : ' VIM '
    if g:crystalline_show_devicons && g:crystalline_show_vim_logo
        " Show Vim Logo in Tabline
        let g:crystalline_vimlabel = " \ue7c5  "
    endif
endfunction

function! crystalline_settings#Init() abort
    setglobal noshowmode

    " CtrlP Integration
    let g:ctrlp_status_func = {
                \ 'main': 'crystalline_settings#ctrlp#MainStatus',
                \ 'prog': 'crystalline_settings#ctrlp#ProgressStatus',
                \ }

    " Tagbar Integration
    let g:tagbar_status_func = 'crystalline_settings#tagbar#Status'

    " ZoomWin Integration
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
endfunction
