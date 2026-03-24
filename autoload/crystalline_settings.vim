vim9script

export def Trim(str: string): string
    if exists('*trim')
        return trim(str)
    else
        return substitute(str, '^\s*\(.\{-}\)\s*$', '\1', '')
    endif
enddef

export def ShortenPath(filename: string): string
    if exists('*pathshorten')
        return pathshorten(filename)
    else
        return substitute(filename, '\v\w\zs.{-}\ze(\\|/)', '', 'g')
    endif
enddef

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
        filename = ShortenPath(filename)
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

export def Init()
    setglobal noshowmode laststatus=2

    # Disable NERDTree statusline
    g:NERDTreeStatusline = -1

    # CtrlP Integration
    if exists(':CtrlP') == 2
        g:ctrlp_status_func = {
            main: 'crystalline_settings#ctrlp#MainStatus',
            prog: 'crystalline_settings#ctrlp#ProgressStatus',
        }
    endif

    # Tagbar Integration
    if exists(':Tagbar') == 2
        g:tagbar_status_func = 'crystalline_settings#tagbar#Status'
    endif

    if exists(':ZoomWin') == 2
        g:crystalline_zoomwin_funcref = []

        if exists('g:ZoomWin_funcref')
            if type(g:ZoomWin_funcref) == v:t_func
                g:crystalline_zoomwin_funcref = [g:ZoomWin_funcref]
            elseif type(g:ZoomWin_funcref) == v:t_list
                g:crystalline_zoomwin_funcref = g:ZoomWin_funcref
            endif
            g:crystalline_zoomwin_funcref = uniq(copy(g:crystalline_zoomwin_funcref))
        endif

        g:ZoomWin_funcref = function('crystalline_settings#zoomwin#Status')
    endif
enddef
