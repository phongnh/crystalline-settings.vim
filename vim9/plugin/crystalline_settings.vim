vim9script

# crystalline_settings.vim
# Maintainer: Phong Nguyen
# Version:    1.0.0

if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    finish
endif

g:loaded_vim_crystalline_settings = 1

# Crystalline Settings
g:crystalline_powerline_fonts = get(g:, 'crystalline_powerline_fonts', 0)
g:crystalline_shorten_path    = get(g:, 'crystalline_shorten_path', 0)
g:crystalline_show_short_mode = get(g:, 'crystalline_show_short_mode', 0)
g:crystalline_show_git_branch = get(g:, 'crystalline_show_git_branch', 0)
g:crystalline_show_linenr     = get(g:, 'crystalline_show_linenr', 0)
g:crystalline_show_devicons   = get(g:, 'crystalline_show_devicons', 0) && crystalline_settings#devicons#Detect()

# Window width
g:crystalline_winwidth_config = extend({
    'compact': 80,
    'default': 100,
    'normal':  120,
}, get(g:, 'crystalline_winwidth_config', {}))

# Improved Model Labels
g:crystalline_mode_labels = {
    'n':      ' NORMAL ',
    'c':      ' COMMAND ',
    'r':      ' NORMAL ',
    '!':      ' NORMAL ',
    'i':      ' INSERT ',
    't':      ' TERMINAL ',
    'v':      ' VISUAL ',
    'V':      ' V-LINE ',
    "\<C-v>": ' V-BLOCK ',
    's':      ' SELECT ',
    'S':      ' S-LINE ',
    "\<C-s>": ' S-BLOCK ',
    'R':      ' REPLACE ',
    '':       '',
}

# Short Modes
g:crystalline_short_mode_labels = {
    'n':      ' N ',
    'c':      ' C ',
    'r':      ' N ',
    '!':      ' N ',
    'i':      ' I ',
    't':      ' T ',
    'v':      ' V ',
    'V':      ' L ',
    "\<C-v>": ' B ',
    's':      ' S ',
    'S':      ' S-L ',
    "\<C-s>": ' S-B ',
    'R':      ' R ',
    '':       '',
}

if g:crystalline_show_short_mode
    g:crystalline_mode_labels = copy(g:crystalline_short_mode_labels)
endif

# Symbols: https://en.wikipedia.org/wiki/Enclosed_Alphanumerics
g:crystalline_symbols = {
    'logo':      '',
    'dos':       '[dos]',
    'mac':       '[mac]',
    'unix':      '[unix]',
    'linenr':    '☰',
    'branch':    '⎇ ',
    'readonly':  '',
    'bomb':      '🅑 ',
    'noeol':     '∉ ',
    'clipboard': '🅒 ',
    'paste':     '🅟 ',
    'ellipsis':  '…',
}

if g:crystalline_powerline_fonts || g:crystalline_show_devicons
    extend(g:crystalline_symbols, {
        'linenr':   "\ue0a1",
        'branch':   "\ue0a0",
        'readonly': "\ue0a2",
    })
    crystalline_settings#powerline#SetSeparators(get(g:, 'crystalline_powerline_style', 'default'))
else
    g:crystalline_separators = [
        { 'ch': '', 'alt_ch': '|', 'dir': '>' },
        { 'ch': '', 'alt_ch': '|', 'dir': '<' },
    ]
    g:crystalline_symbols = extend(g:crystalline_symbols, {
        'left':      '',
        'right':     '',
        'left_sep':  '|',
        'right_sep': '|',
    })
endif

if g:crystalline_show_devicons
    extend(g:crystalline_symbols, {
        'logo':  " \ue7c5  ",
        'bomb':  "\ue287 ",
        'noeol': "\ue293 ",
        'dos':   "\ue70f",
        'mac':   "\ue711",
        'unix':  "\ue712",
    })
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
endif

def g:CrystallineStatuslineFn(winnr: number): string
    g:crystalline_group_suffix = g:GroupSuffix()
    var current = winnr == winnr()
    if current
        return join([
            '%<',
            crystalline#ModeHiItem('A'),
            crystalline_settings#Group('crystalline_settings#sections#SectionA(' .. winnr .. ')'),
            crystalline#Sep(0, crystalline#ModeSepGroup('A'), 'B'),
            crystalline_settings#Group('crystalline_settings#sections#SectionB(' .. winnr .. ')'),
            crystalline#Sep(0, 'B', 'Fill'),
            crystalline_settings#Group('crystalline_settings#sections#SectionC(' .. winnr .. ')'),
            '%=',
            '%<',
            crystalline_settings#Group('crystalline_settings#sections#SectionX(' .. winnr .. ')'),
            crystalline#Sep(1, 'Fill', 'B'),
            crystalline_settings#Group('crystalline_settings#sections#SectionY(' .. winnr .. ')'),
            crystalline#Sep(1, 'B', 'A'),
            crystalline_settings#Group('crystalline_settings#sections#SectionZ(' .. winnr .. ')'),
        ], '')
    else
        return join([
            '%<',
            crystalline#HiItem('Fill'),
            crystalline_settings#Group('crystalline_settings#sections#InactiveSectionA(' .. winnr .. ')'),
        ], '')
    endif
enddef

def g:GroupSuffix(): string
    if mode() ==# 'i' && &paste
        return '2'
    endif
    if &modified
        return '1'
    endif
    return ''
enddef

def g:CrystallineTabFn(tab: number, buf: number, max_width: number, is_sel: bool): list<any>
    # Return early
    if max_width <= 0
        return ['', 0]
    endif

    # Get left/right components
    var left = g:crystalline_tab_left
    var right = getbufvar(buf, '&mod') ? g:crystalline_tab_mod : g:crystalline_tab_nomod
    var lr_width = strchars(left) + strchars(right)
    var max_name_width = max_width - lr_width

    var nr = crystalline#DefaultTablineIsBuffers() ? buf : tab

    # Get name
    var name = bufname(buf)
    name = nr .. ' ' .. (!empty(name) ? fnamemodify(name, ':t') : g:crystalline_tab_empty)
    var name_width = strchars(name)

    # Shorten tab
    var tab_str: string
    var tabwidth: number
    if max_name_width <= 0
        tab_str = strcharpart(name, name_width - max_width)
        tabwidth = min([name_width, max_width])
    else
        tab_str = left .. strcharpart(name, name_width - max_name_width) .. right
        tabwidth = lr_width + min([name_width, max_name_width])
    endif

    return [crystalline#EscapeStatuslineString(tab_str), tabwidth]
enddef

def g:CrystallineTablineFn(): string
    g:crystalline_group_suffix = g:GroupSuffix()
    var max_width = &columns

    var right = '%='

    right ..= crystalline#Sep(1, 'TabFill', 'TabType')
    max_width -= 1

    var vimlabel = g:crystalline_symbols.logo
    right ..= vimlabel
    max_width -= strchars(vimlabel)

    var max_tabs = 10

    return crystalline#DefaultTabline({
        'enable_sep': 1,
        'max_tabs': max_tabs,
        'max_width': max_width
    }) .. right
enddef

command! -nargs=1 -complete=custom,crystalline_settings#theme#List CrystallineTheme crystalline#SetTheme(<f-args>)

augroup CrystallineSettings
    autocmd!
    autocmd CmdwinEnter * set filetype=cmdline syntax=vim
    autocmd User GoyoEnter ++nested crystalline_settings#goyo#OnEnter()
    autocmd User GoyoLeave ++nested crystalline_settings#goyo#OnLeave()
    autocmd User CrystallineSetTheme ++once crystalline_settings#theme#Detect()
    autocmd ColorScheme * crystalline_settings#theme#Find()
    if v:vim_did_enter
        crystalline_settings#theme#Detect()
    else
        autocmd VimEnter * ++once crystalline_settings#theme#Detect()
    endif
augroup END
