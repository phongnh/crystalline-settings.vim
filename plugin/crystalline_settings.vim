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
let g:crystalline_powerline_fonts = get(g:, 'crystalline_powerline_fonts', 0)
let g:crystalline_shorten_path    = get(g:, 'crystalline_shorten_path', 0)
let g:crystalline_show_short_mode = get(g:, 'crystalline_show_short_mode', 0)
let g:crystalline_show_git_branch = get(g:, 'crystalline_show_git_branch', 0)
let g:crystalline_show_linenr     = get(g:, 'crystalline_show_linenr', 0)
let g:crystalline_show_devicons   = get(g:, 'crystalline_show_devicons', 0) && crystalline_settings#devicons#Detect()

" Window width
let g:crystalline_winwidth_config = extend({
            \ 'compact': 60,
            \ 'default': 90,
            \ 'normal':  120,
            \ }, get(g:, 'crystalline_winwidth_config', {}))

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

" Short Modes
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

function! g:CrystallineStatuslineFn(winnr) abort
    let g:crystalline_group_suffix = g:GroupSuffix()
    let l:current = a:winnr == winnr()
    if l:current
        return join([
                    \ '%<',
                    \ crystalline#ModeHiItem('A'),
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#Mode(%d)', a:winnr)),
                    \ crystalline#Sep(0, crystalline#ModeSepGroup('A'), 'B'),
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#Plugin(%d)', a:winnr)),
                    \ crystalline#Sep(0, 'B', 'Fill'),
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#FileName(%d)', a:winnr)),
                    \ '%=',
                    \ '%<',
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#Info(%d)', a:winnr)),
                    \ crystalline#Sep(1, 'Fill', 'B'),
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#Settings(%d)', a:winnr)),
                    \ crystalline#Sep(1, 'B', 'A'),
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#Buffer(%d)', a:winnr)),
                    \ ], '')
    else
        return crystalline#HiItem('InactiveFill') .
                    \ '%<' .
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#InactiveMode(%d)', a:winnr))
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

    let l:nr = crystalline#DefaultTablineIsBuffers() ? a:buf : a:tab

    " Get name
    let l:name = bufname(a:buf)
    if l:name ==# ''
        let l:name = printf('%d: %s', l:nr, g:crystalline_tab_empty)
        let l:name_width = strchars(l:name)
    else
        let l:name = printf('%d: %s', l:nr, fnamemodify(l:name, ':t'))
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


function! g:CrystallineTablineFn()
    let g:crystalline_group_suffix = g:GroupSuffix()
    let l:max_width = &columns

    let l:right = '%='

    let l:right .= crystalline#Sep(1, 'TabFill', 'TabType')
    let l:max_width -= 1

    let l:vimlabel = g:crystalline_symbols.logo
    let l:right .= l:vimlabel
    let l:max_width -= strchars(l:vimlabel)

    let l:max_tabs = 10

    return crystalline#DefaultTabline({
                \ 'enable_sep': 1,
                \ 'max_tabs': l:max_tabs,
                \ 'max_width': l:max_width
                \ }) . l:right
endfunction

command! -nargs=1 -complete=custom,crystalline_settings#theme#List CrystallineTheme call crystalline#SetTheme(<f-args>)

augroup CrystallineSettings
    autocmd!
    autocmd User CrystallineSetTheme ++once call crystalline_settings#theme#Detect()
    autocmd ColorScheme * call crystalline_settings#theme#Find()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
