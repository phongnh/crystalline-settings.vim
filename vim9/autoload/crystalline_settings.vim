vim9script

# Cache window width to avoid repeated winwidth() calls
var cached_winwidth = 0
var cached_winwidth_nr = 0

def GetWinWidthImpl(winnr: number = 0): number
    # Cache is only valid for current window in current update
    if winnr == cached_winwidth_nr && cached_winwidth > 0
        return cached_winwidth
    endif
    cached_winwidth = winwidth(winnr)
    cached_winwidth_nr = winnr
    return cached_winwidth
enddef

# Expose for use in other modules
export def GetWinWidth(...args: list<any>): number
    var winnr = get(args, 0, 0)
    return GetWinWidthImpl(winnr)
enddef

# Clear width cache
export def ClearWidthCache()
    cached_winwidth = 0
    cached_winwidth_nr = 0
enddef

export def FormatFileName(fname: string, winwidth: number, max_width: number): string
    var filename = fname

    if winwidth < g:crystalline_winwidth_config.default
        return fnamemodify(filename, ':t')
    endif

    if strlen(filename) > winwidth && (filename =~# '^[~/]') && g:crystalline_shorten_path
        filename = pathshorten(filename)
    endif

    var max_w = min([winwidth, max_width])

    if strlen(filename) > max_w
        filename = fnamemodify(filename, ':t')
    endif

    return filename
enddef

export def Group(exp: string): string
    if exp =~# '^%'
        return '%( ' .. exp .. ' %)'
    else
        return '%( %{' .. exp .. '} %)'
    endif
enddef

export def Concatenate(parts: list<string>, ...args: list<any>): string
    var separator = get(args, 0, 0) ? g:crystalline_symbols.right_sep : g:crystalline_symbols.left_sep
    return join(filter(copy(parts), 'v:val !=# ""'), ' ' .. separator .. ' ')
enddef
