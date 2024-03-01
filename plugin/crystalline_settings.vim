" crystalline_settings.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    finish
endif

let g:loaded_vim_crystalline_settings = 1

let s:save_cpo = &cpo
set cpo&vim

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

let s:crystalline_show_devicons = g:crystalline_show_devicons && crystalline_settings#devicons#Detect()

let g:crystalline_vimlabel = has('nvim') ? ' NVIM ' : ' VIM '
if g:crystalline_show_vim_logo && s:crystalline_show_devicons
    " Show Vim Logo in Tabline
    let g:crystalline_vimlabel = " \ue7c5  "
endif

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

function! StatusLineActiveMode(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return l:mode['name']
    endif

    return crystalline_settings#Concatenate([
                \ crystalline_settings#parts#Mode(),
                \ crystalline_settings#parts#Clipboard(),
                \ crystalline_settings#parts#Paste(),
                \ crystalline_settings#parts#Spell(),
                \ ])
endfunction

function! StatusLineLeftFill(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'lfill', '')
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if g:crystalline_show_git_branch && l:winwidth >= g:crystalline_winwidth_config.small
        return crystalline_settings#Concatenate([
                    \ crystalline_settings#git#Branch(l:winwidth),
                    \ crystalline_settings#parts#FileName(l:winwidth - 2),
                    \ ])
    endif

    return crystalline_settings#parts#FileName(l:winwidth - 2)
endfunction

function! StatusLineLeftExtra(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'lextra', '')
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth >= g:crystalline_winwidth_config.small
    endif

    return ''
endfunction

function! StatusLineRightMode(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'rmode', '')
    endif

    let l:winnr = get(a:, 1, 0)
    return crystalline_settings#parts#FileInfo(l:winnr)
endfunction

function! StatusLineRightFill(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'rfill', '')
    endif

    let l:winnr = winwidth(get(a:, 1, 0))
    let l:compact = crystalline_settings#IsCompact(l:winnr)
    return crystalline_settings#parts#Indentation(l:compact)
endfunction

function! StatusLineRightExtra(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'rextra', '')
    endif

    return ''
endfunction

function! StatusLineInactiveMode(...) abort
    " show only custom mode in inactive buffer
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return crystalline_settings#Concatenate([
                    \ l:mode['name'],
                    \ get(l:mode, 'lfill_inactive', ''),
                    \ ])
    endif

    " plugin/statusline.vim[+]
    return crystalline_settings#parts#InactiveFileName()
endfunction

function! g:CrystallineStatuslineFn(winnr) abort
    let l:current = a:winnr == winnr()
    if l:current
        return join([
                    \ '%<',
                    \ crystalline#ModeHiItem('A'),
                    \ crystalline_settings#Group(printf('StatusLineActiveMode(%d)', a:winnr)),
                    \ crystalline#Sep(0, crystalline#ModeSepGroup('A'), 'B'),
                    \ crystalline_settings#Group(printf('StatusLineLeftFill(%d)', a:winnr)),
                    \ crystalline#Sep(0, 'B', 'Fill'),
                    \ crystalline_settings#Group(printf('StatusLineLeftExtra(%d)', a:winnr)),
                    \ '%=',
                    \ '%<',
                    \ crystalline_settings#Group(printf('StatusLineRightExtra(%d)', a:winnr)),
                    \ crystalline#Sep(1, 'Fill', 'B'),
                    \ crystalline_settings#Group(printf('StatusLineRightFill(%d)', a:winnr)),
                    \ crystalline#Sep(1, 'B', 'A'),
                    \ crystalline_settings#Group(printf('StatusLineRightMode(%d)', a:winnr)),
                    \ ], '')
    else
        return crystalline#HiItem('InactiveFill') .
                    \ '%<' .
                    \ crystalline_settings#Group(printf('StatusLineInactiveMode(%d)', a:winnr))
    endif
endfunction

function! g:GroupSuffix()
    if mode() ==# 'i' && &paste
        return '2'
    endif
    if &modified
        return '1'
    endif
    return ''
endfunction

function! g:CrystallineTablineFn()
    let g:crystalline_group_suffix = g:GroupSuffix()
    let l:max_width = &columns

    let l:right = '%='

    let l:right .= crystalline#Sep(1, 'TabFill', 'TabType')
    let l:max_width -= 1

    let l:vimlabel = g:crystalline_vimlabel
    let l:right .= l:vimlabel
    let l:max_width -= strchars(l:vimlabel)

    let l:max_tabs = 10

    return crystalline#DefaultTabline({
                \ 'enable_sep': g:crystalline_enable_sep,
                \ 'max_tabs': l:max_tabs,
                \ 'max_width': l:max_width
                \ }) . l:right
endfunction

function! g:CrystallineTabFn(tab, buf, max_width, is_sel) abort
    " Return early
    if a:max_width <= 0
        return ['', 0]
    endif

    " Get left/right components
    let l:left = g:crystalline_tab_left
    let l:right = getbufvar(a:buf, '&mod') ? g:crystalline_tab_mod : g:crystalline_tab_nomod
    let l:lr_width = strchars(l:left) + strchars(l:right)
    let l:max_name_width = a:max_width - l:lr_width

    " Get name
    let l:name = bufname(a:buf)
    if l:name ==# ''
        let l:name = g:crystalline_tab_empty
        let l:name_width = strchars(l:name)
    else
        let l:name = fnamemodify(l:name, ':t')
        let l:name_width = strchars(l:name)
    endif

    " Shorten tab
    if l:max_name_width <= 0
        let l:tab = strcharpart(l:name, l:name_width - a:max_width)
        let l:tabwidth = min([l:name_width, a:max_width])
    else
        let l:tab = l:left . strcharpart(l:name, l:name_width - l:max_name_width) . l:right
        let l:tabwidth = l:lr_width + min([l:name_width, l:max_name_width])
    endif

    return [crystalline#EscapeStatuslineString(l:tab), l:tabwidth]
endfunction

augroup CrystallineSettings
    autocmd!
    autocmd VimEnter * call crystalline_settings#Init()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
