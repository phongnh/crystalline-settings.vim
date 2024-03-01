" crystalline_settings.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    finish
endif

let g:loaded_vim_crystalline_settings = 1

let s:save_cpo = &cpo
set cpo&vim

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

function! s:FileNameStatus(...) abort
    let winwidth = get(a:, 1, 100)
    return crystalline_settings#parts#Readonly() . crystalline_settings#FormatFileName(crystalline_settings#FileName(), winwidth, 50) . crystalline_settings#parts#Modified()
endfunction

function! s:InactiveFileNameStatus(...) abort
    return crystalline_settings#parts#Readonly() . crystalline_settings#FileName() . crystalline_settings#parts#Modified()
endfunction

function! StatusLineActiveMode(...) abort
    " custom status
    let l:mode = s:CustomMode()
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
    let l:mode = s:CustomMode()
    if len(l:mode)
        return get(l:mode, 'lfill', '')
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if g:crystalline_show_git_branch && l:winwidth >= g:crystalline_winwidth_config.small
        return crystalline_settings#Concatenate([
                    \ crystalline_settings#git#Branch(l:winwidth),
                    \ s:FileNameStatus(l:winwidth - 2),
                    \ ])
    endif

    return s:FileNameStatus(l:winwidth - 2)
endfunction

function! StatusLineLeftExtra(...) abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return get(l:mode, 'lextra', '')
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth >= g:crystalline_winwidth_config.small
    endif

    return ''
endfunction

function! StatusLineRightMode(...) abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return get(l:mode, 'rmode', '')
    endif

    let l:winnr = get(a:, 1, 0)
    return crystalline_settings#parts#FileInfo(l:winnr)
endfunction

function! StatusLineRightFill(...) abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return get(l:mode, 'rfill', '')
    endif

    let l:winnr = winwidth(get(a:, 1, 0))
    let l:compact = crystalline_settings#IsCompact(l:winnr)
    return crystalline_settings#parts#Indentation(l:compact)
endfunction

function! StatusLineRightExtra(...) abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return get(l:mode, 'rextra', '')
    endif

    return ''
endfunction

function! StatusLineInactiveMode(...) abort
    " show only custom mode in inactive buffer
    let l:mode = s:CustomMode()
    if len(l:mode)
        return crystalline_settings#Concatenate([
                    \ l:mode['name'],
                    \ get(l:mode, 'lfill_inactive', ''),
                    \ ])
    endif

    " plugin/statusline.vim[+]
    return s:InactiveFileNameStatus()
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

" Plugin Integration
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

function! s:CustomMode() abort
    let fname = expand('%:t')

    if has_key(g:crystalline_filename_modes, fname)
        let result = {
                    \ 'name': g:crystalline_filename_modes[fname],
                    \ }

        if fname ==# 'ControlP'
            return extend(result, crystalline_settings#ctrlp#Mode())
        endif

        if fname ==# '__Tagbar__'
            return extend(result, crystalline_settings#tagbar#Mode())
        endif

        if fname ==# '__CtrlSF__'
            return extend(result, crystalline_settings#ctrlsf#Mode())
        endif

        if fname ==# '__CtrlSFPreview__'
            return extend(result, crystalline_settings#ctrlsf#PreviewMode())
        endif

        return result
    endif

    if fname =~# '^NrrwRgn_\zs.*\ze_\d\+$'
        return crystalline_settings#nrrwrgn#Mode()
    endif

    let ft = crystalline_settings#BufferType()
    if has_key(g:crystalline_filetype_modes, ft)
        let result = {
                    \ 'name': g:crystalline_filetype_modes[ft],
                    \ }

        if has_key(g:crystalline_plugin_modes, ft)
            return extend(result, function(g:crystalline_plugin_modes[ft])())
        endif

        return result
    endif

    return {}
endfunction

" Disable NERDTree statusline
let g:NERDTreeStatusline = -1

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

let &cpo = s:save_cpo
unlet s:save_cpo
