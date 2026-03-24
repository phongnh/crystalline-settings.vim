vim9script

var crystalline_separator_styles: dict<list<dict<any>>>
var styles_initialized = false

def InitPowerlineStyles()
    if styles_initialized
        return
    endif
    styles_initialized = true

    var separator_styles = {
        default: {left: "\ue0b0", right: "\ue0b2"},
        angle:   {left: "\ue0b0", right: "\ue0b2"},
        curvy:   {left: "\ue0b4", right: "\ue0b6"},
        slant:   {left: "\ue0bc", right: "\ue0ba"},
        '><':      {left: "\ue0b0", right: "\ue0b2"},
        '>(':      {left: "\ue0b0", right: "\ue0b6"},
        '>\':      {left: "\ue0b0", right: "\ue0be"},
        '>/':      {left: "\ue0b0", right: "\ue0ba"},
        ')(':      {left: "\ue0b4", right: "\ue0b6"},
        ')<':      {left: "\ue0b4", right: "\ue0b2"},
        ')\':      {left: "\ue0b4", right: "\ue0be"},
        ')/':      {left: "\ue0b4", right: "\ue0ba"},
        '\\':      {left: "\ue0b8", right: "\ue0be"},
        '\/':      {left: "\ue0b8", right: "\ue0ba"},
        '\<':      {left: "\ue0b8", right: "\ue0b2"},
        '\(':      {left: "\ue0b8", right: "\ue0b6"},
        '//':      {left: "\ue0bc", right: "\ue0ba"},
        '/\':      {left: "\ue0bc", right: "\ue0be"},
        '/<':      {left: "\ue0bc", right: "\ue0b2"},
        '/(':      {left: "\ue0bc", right: "\ue0b6"},
        '||':      {left: '',       right: ''},
    }

    var subseparator_styles = {
        default: {left: "\ue0b1", right: "\ue0b3"},
        angle:   {left: "\ue0b1", right: "\ue0b3"},
        curvy:   {left: "\ue0b5", right: "\ue0b7"},
        slant:   {left: "\ue0bb", right: "\ue0bb"},
        '><':      {left: "\ue0b1", right: "\ue0b3"},
        '>(':      {left: "\ue0b1", right: "\ue0b7"},
        '>\':      {left: "\ue0b1", right: "\ue0b9"},
        '>/':      {left: "\ue0b1", right: "\ue0bb"},
        ')(':      {left: "\ue0b5", right: "\ue0b7"},
        ')<':      {left: "\ue0b5", right: "\ue0b3"},
        ')\':      {left: "\ue0b5", right: "\ue0b9"},
        ')/':      {left: "\ue0b5", right: "\ue0bb"},
        '\\':      {left: "\ue0b9", right: "\ue0b9"},
        '\/':      {left: "\ue0b9", right: "\ue0bb"},
        '\<':      {left: "\ue0b9", right: "\ue0b3"},
        '\(':      {left: "\ue0b9", right: "\ue0b7"},
        '//':      {left: "\ue0bb", right: "\ue0bb"},
        '/\':      {left: "\ue0bd", right: "\ue0b9"},
        '/<':      {left: "\ue0bb", right: "\ue0b3"},
        '/(':      {left: "\ue0bb", right: "\ue0b7"},
        '||':      {left: '|',      right: '|'},
    }

    crystalline_separator_styles = {}

    for [style, separator] in items(separator_styles)
        const subseparator = subseparator_styles[style]
        crystalline_separator_styles[style] = [
            {ch: separator['left'],  alt_ch: subseparator['left'],  dir: '>'},
            {ch: separator['right'], alt_ch: subseparator['right'], dir: '<'},
        ]
    endfor
enddef

export def SetSeparators(style: any)
    InitPowerlineStyles()

    var style_str = 'default'

    if type(style) == v:t_string && !empty(style)
        style_str = style
    endif

    if style_str ==? 'random'
        const rand = str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1 :])
        style_str = keys(crystalline_separator_styles)[rand % len(crystalline_separator_styles)]
    endif

    g:crystalline_separators = deepcopy(get(crystalline_separator_styles, style_str, crystalline_separator_styles['default']))
    g:crystalline_symbols = extend(g:crystalline_symbols, {
        left:      g:crystalline_separators[0].ch,
        right:     g:crystalline_separators[1].ch,
        left_sep:  g:crystalline_separators[0].alt_ch,
        right_sep: g:crystalline_separators[1].alt_ch,
    })
enddef
