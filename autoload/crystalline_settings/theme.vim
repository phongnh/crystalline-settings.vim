vim9script

# Theme mappings
var crystalline_theme_mappings = extend({
    '^\(solarized\|soluarized\|flattened\|neosolarized\)': 'solarized8',
    '^gruvbox': 'gruvbox',
    '^habamax$': 'onehalfdark',
    '^retrobox$': 'gruvbox',
}, get(g:, 'crystalline_theme_mappings', {}))

var crystalline_themes: list<string>

def LoadThemes()
    if empty(crystalline_themes)
        crystalline_themes = map(split(globpath(&rtp, 'autoload/crystalline/theme/*.vim')), "fnamemodify(v:val, ':t:r')")
    endif
enddef

def FindTheme()
    g:crystalline_theme = tolower(tr(get(g:, 'colors_name', 'default'), ' -', '__'))
    if index(crystalline_themes, g:crystalline_theme) > -1
        return
    endif

    for [pattern, theme] in items(crystalline_theme_mappings)
        if match(g:crystalline_theme, pattern) > -1 && index(crystalline_themes, theme) > -1
            g:crystalline_theme = theme
            return
        endif
    endfor

    g:crystalline_theme = 'default'
enddef

export def List(...args: list<any>): string
    return join(crystalline_themes, "\n")
enddef

export def Find()
    LoadThemes()
    FindTheme()
enddef

export def Detect()
    if has('vim_starting') && exists('g:crystalline_theme') && g:crystalline_theme ==# 'default'
        Find()
        if g:crystalline_theme !=# 'default'
            crystalline#SetTheme(g:crystalline_theme)
        endif
    elseif !exists('g:crystalline_theme')
        Find()
        crystalline#SetTheme(g:crystalline_theme)
    endif
enddef
