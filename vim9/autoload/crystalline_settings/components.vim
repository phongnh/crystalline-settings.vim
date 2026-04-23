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
    ControlP:            'crystalline_settings#ctrlp#Statusline',
    '__CtrlSF__':        'crystalline_settings#ctrlsf#Statusline',
    '__CtrlSFPreview__': 'crystalline_settings#ctrlsf#PreviewStatusline',
    '__flygrep__':       'crystalline_settings#flygrep#Statusline',
    '__Tagbar__':        'crystalline_settings#tagbar#Statusline',
}

const crystalline_filetype_integrations = {
    cmdline:         'crystalline_settings#cmdline#Statusline',
    ctrlp:           'crystalline_settings#ctrlp#Statusline',
    nerdtree:        'crystalline_settings#nerdtree#Statusline',
    netrw:           'crystalline_settings#netrw#Statusline',
    dirvish:         'crystalline_settings#dirvish#Statusline',
    molder:          'crystalline_settings#molder#Statusline',
    vaffle:          'crystalline_settings#vaffle#Statusline',
    fern:            'crystalline_settings#fern#Statusline',
    undotree:        'crystalline_settings#undotree#Statusline',
    diff:            'crystalline_settings#diff#Statusline',
    tagbar:          'crystalline_settings#tagbar#Statusline',
    NrrwRgn:         'crystalline_settings#nrrwrgn#Statusline',
    git:             'crystalline_settings#git#Statusline',
    gitcommit:       'crystalline_settings#gitcommit#Statusline',
    gitrebase:       'crystalline_settings#gitrebase#Statusline',
    fugitive:        'crystalline_settings#fugitive#Statusline',
    GV:              'crystalline_settings#gv#Statusline',
    terminal:        'crystalline_settings#terminal#Statusline',
    help:            'crystalline_settings#help#Statusline',
    man:             'crystalline_settings#man#Statusline',
    qf:              'crystalline_settings#quickfix#Statusline',
    ctrlsf:          'crystalline_settings#ctrlsf#Statusline',
    GrepperSide:     'crystalline_settings#grepper#Statusline',
    SpaceVimFlyGrep: 'crystalline_settings#flygrep#Statusline',
}

const spelllang_maps = { 'en_us': 'US', 'en_gb': 'GB' }

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
    return &spell ? split(&spelllang, ',')->map((_k, v) => get(spelllang_maps, v, toupper(v)))->join('/') : ''
enddef

export def Indentation(...args: list<any>): string
    const compact = get(args, 0, IsCompact())
    if &expandtab
        return (compact ? 'SPC' : 'Spaces') .. ': ' .. shiftwidth()
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

export def Progress(...args: list<any>): string
    if line('w0') == 1 && line('w$') == line('$')
        return 'All'
    elseif line('w0') == 1
        return 'Top'
    elseif line('w$') == line('$')
        return 'Bot'
    else
        return (line('.') * 100 / line('$')) .. '%'
    endif
enddef

export def Position(...args: list<any>): string
    return printf('%4d:%-3d', line('.'), charcol('.'))
enddef

export def Ruler(...args: list<any>): string
    return Position() .. ' ' .. Progress()
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
        return crystalline_settings#nrrwrgn#Statusline()
    endif

    if has_key(crystalline_filetype_modes, ft)
        return {section_a: crystalline_filetype_modes[ft]}
    endif

    if has_key(crystalline_filename_modes, fname)
        return {section_a: crystalline_filename_modes[fname]}
    endif

    return {}
enddef

export def Branch(...args: list<any>): string
    return crystalline_settings#gitbranch#Component()
enddef
