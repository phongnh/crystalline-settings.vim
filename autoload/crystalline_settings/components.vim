vim9script

# Alternate status dictionaries
const crystalline_filename_modes = {
    ControlP:             'CtrlP',
    '__CtrlSF__':           'CtrlSF',
    '__CtrlSFPreview__':    'Preview',
    '__flygrep__':          'FlyGrep',
    '__Tagbar__':           'Tagbar',
    '__Gundo__':            'Gundo',
    '__Gundo_Preview__':    'Gundo Preview',
    '__Mundo__':            'Mundo',
    '__Mundo_Preview__':    'Mundo Preview',
    '[BufExplorer]':        'BufExplorer',
    '[Command Line]':       'Command Line',
    '[Plugins]':            'Plugins',
    '__committia_status__': 'Git Status',
    '__committia_diff__':   'Git Diff',
    '__doc__':              'Document',
    '__LSP_SETTINGS__':     'LSP Settings',
}

const crystalline_filetype_modes = {
    bufexplorer:       'BufExplorer',
    simplebuffer:      'SimpleBuffer',
    netrw:             'Netrw',
    molder:            'Molder',
    dirvish:           'Dirvish',
    vaffle:            'Vaffle',
    nerdtree:          'NERDTree',
    fern:              'Fern',
    Mundo:             'Mundo',
    MundoDiff:         'Mundo Preview',
    undotree:          'Undo',
    diff:              'Diff',
    gundo:             'Gundo',
    startify:          'Startify',
    dashboard:         'Dashboard',
    tagbar:            'Tagbar',
    'vim-plug':        'Plugins',
    terminal:          'TERMINAL',
    help:              'HELP',
    man:               'MAN',
    qf:                'Quickfix',
    godoc:             'GoDoc',
    gedoc:             'GeDoc',
    gitcommit:         'Commit Message',
    gitrebase:         'Git Rebase',
    fugitive:          'Git Status',
    fugitiveblame:     'FugitiveBlame',
    gitmessengerpopup: 'Git Messenger',
    GV:                'GV',
    agit:              'Agit',
    agit_diff:         'Git Diff',
    agit_stat:         'Git Stat',
    GrepperSide:       'GrepperSide',
    SpaceVimFlyGrep:   'FlyGrep',
    startuptime:       'StartupTime',
}

const crystalline_filename_integrations = {
    ControlP:            'crystalline_settings#ctrlp#Mode',
    '__CtrlSF__':        'crystalline_settings#ctrlsf#Mode',
    '__CtrlSFPreview__': 'crystalline_settings#ctrlsf#PreviewMode',
    '__flygrep__':       'crystalline_settings#flygrep#Mode',
    '__Tagbar__':        'crystalline_settings#tagbar#Mode',
}

const crystalline_filetype_integrations = {
    cmdline:         'crystalline_settings#cmdline#Mode',
    ctrlp:           'crystalline_settings#ctrlp#Mode',
    nerdtree:        'crystalline_settings#nerdtree#Mode',
    netrw:           'crystalline_settings#netrw#Mode',
    dirvish:         'crystalline_settings#dirvish#Mode',
    molder:          'crystalline_settings#molder#Mode',
    vaffle:          'crystalline_settings#vaffle#Mode',
    fern:            'crystalline_settings#fern#Mode',
    undotree:        'crystalline_settings#undotree#Mode',
    diff:            'crystalline_settings#diff#Mode',
    tagbar:          'crystalline_settings#tagbar#Mode',
    NrrwRgn:         'crystalline_settings#nrrwrgn#Mode',
    git:             'crystalline_settings#git#Mode',
    gitcommit:       'crystalline_settings#gitcommit#Mode',
    gitrebase:       'crystalline_settings#gitrebase#Mode',
    fugitive:        'crystalline_settings#fugitive#Mode',
    GV:              'crystalline_settings#gv#Mode',
    terminal:        'crystalline_settings#terminal#Mode',
    help:            'crystalline_settings#help#Mode',
    man:             'crystalline_settings#man#Mode',
    qf:              'crystalline_settings#quickfix#Mode',
    ctrlsf:          'crystalline_settings#ctrlsf#Mode',
    GrepperSide:     'crystalline_settings#grepper#Mode',
    SpaceVimFlyGrep: 'crystalline_settings#flygrep#Mode',
}

def BufferType(): string
    return !empty(&filetype) ? &filetype : &buftype
enddef

def GetFileName(): string
    const fname = expand('%')
    return !empty(fname) ? fnamemodify(fname, ':~:.') : '[No Name]'
enddef

def IsClipboardEnabled(): bool
    return stridx(&clipboard, 'unnamed') > -1
enddef

def IsCompact(...args: list<any>): bool
    const winnr = get(args, 0, 0)
    return crystalline_settings#GetWinWidth(winnr) <= g:crystalline_winwidth_config.compact ||
        count([
            IsClipboardEnabled(),
            &paste,
            &spell,
            &bomb,
            !&eol,
        ], 1) > 1
enddef

export def Mode(): string
    if IsCompact()
        return trim(get(g:crystalline_short_mode_labels, mode(), ''))
    else
        return trim(crystalline#ModeLabel())
    endif
enddef

export def Clipboard(): string
    return IsClipboardEnabled() ? g:crystalline_symbols.clipboard : ''
enddef

export def Paste(): string
    return &paste ? g:crystalline_symbols.paste : ''
enddef

export def Spell(): string
    return &spell ? toupper(tr(&spelllang, ',', '/')) : ''
enddef

def Shiftwidth(): number
    return exists('*shiftwidth') ? shiftwidth() : &shiftwidth
enddef

export def Indentation(...args: list<any>): string
    const compact = get(args, 0, IsCompact())
    if &expandtab
        return (compact ? 'SPC' : 'Spaces') .. ': ' .. Shiftwidth()
    else
        return (compact ? 'TAB' : 'Tab Size') .. ': ' .. &tabstop
    endif
enddef

def ReadonlyStatus(...args: list<any>): string
    return &readonly ? g:crystalline_symbols.readonly .. ' ' : ''
enddef

def ModifiedStatus(...args: list<any>): string
    if &modified
        return !&modifiable ? '[+-]' : '[+]'
    else
        return !&modifiable ? '[-]' : ''
    endif
enddef

def ZoomedStatus(...args: list<any>): string
    return get(g:, 'crystalline_zoomstate', 0) ? '[Z]' : ''
enddef

export def LineInfo(...args: list<any>): string
    if g:crystalline_show_linenr > 1
        return crystalline_settings#lineinfo#Full()
    elseif g:crystalline_show_linenr > 0
        return crystalline_settings#lineinfo#Simple()
    endif
    return ''
enddef

export def Ruler(...args: list<any>): string
    var percent: string
    if line('w0') == 1 && line('w$') == line('$')
        percent = 'All'
    elseif line('w0') == 1
        percent = 'Top'
    elseif line('w$') == line('$')
        percent = 'Bot'
    else
        percent = (line('.') * 100 / line('$')) .. '%'
    endif

    return printf('%d,%d %s', line('.'), col('.'), percent)
enddef

export def FileEncodingAndFormat(): string
    # Skip encoding check if it's utf-8 and format is unix (common case)
    if &fileencoding ==# 'utf-8' && &fileformat ==# 'unix' && !&bomb && &eol
        return ''
    endif

    var parts: list<string> = []

    const encoding = !empty(&fileencoding) ? &fileencoding : &encoding
    if !empty(encoding) && encoding !=# 'utf-8'
        add(parts, encoding)
    endif

    if &bomb | add(parts, g:crystalline_symbols.bomb) | endif
    if !&eol | add(parts, g:crystalline_symbols.noeol) | endif

    if !empty(&fileformat) && &fileformat !=# 'unix'
        add(parts, get(g:crystalline_symbols, &fileformat, &fileformat))
    endif

    return join(parts, ' ')
enddef

export def FileType(...args: list<any>): string
    return BufferType() .. crystalline_settings#devicons#FileType(expand('%'))
enddef

export def FileName(...args: list<any>): string
    const winwidth = crystalline_settings#GetWinWidth(get(args, 0, 0))
    return ReadonlyStatus() .. crystalline_settings#FormatFileName(GetFileName(), winwidth, 50) .. ZoomedStatus() .. ModifiedStatus()
enddef

export def InactiveFileName(...args: list<any>): string
    return ReadonlyStatus() .. GetFileName() .. ModifiedStatus()
enddef

export def Integration(): dict<any>
    const ft = BufferType()

    if has_key(crystalline_filetype_integrations, ft)
        return function(crystalline_filetype_integrations[ft])()
    endif

    const fname = expand('%:t')

    if has_key(crystalline_filename_integrations, fname)
        return function(crystalline_filename_integrations[fname])()
    elseif fname =~# '^NrrwRgn_\zs.*\ze_\d\+$'
        # Fallback to filename check if NrrwRgn buffer's filetype is not set
        return crystalline_settings#nrrwrgn#Mode()
    endif

    if has_key(crystalline_filetype_modes, ft)
        return {section_a: crystalline_filetype_modes[ft]}
    endif

    if has_key(crystalline_filename_modes, fname)
        return {section_a: crystalline_filename_modes[fname]}
    endif

    return {}
enddef

export def GitBranch(...args: list<any>): string
    if g:crystalline_show_git_branch > 0
        return crystalline_settings#gitbranch#Name()
    endif
    return ''
enddef
