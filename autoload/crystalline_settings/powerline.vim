function! s:InitPowerlineStyles() abort
    if exists('g:crystalline_separator_styles') && type(g:crystalline_separator_styles) == v:t_dict
        return
    endif

    let l:separator_styles = {
                \ '><': { 'left': "\ue0b0", 'right': "\ue0b2" },
                \ '>(': { 'left': "\ue0b0", 'right': "\ue0b6" },
                \ '>\': { 'left': "\ue0b0", 'right': "\ue0be" },
                \ '>/': { 'left': "\ue0b0", 'right': "\ue0ba" },
                \ ')(': { 'left': "\ue0b4", 'right': "\ue0b6" },
                \ ')<': { 'left': "\ue0b4", 'right': "\ue0b2" },
                \ ')\': { 'left': "\ue0b4", 'right': "\ue0be" },
                \ ')/': { 'left': "\ue0b4", 'right': "\ue0ba" },
                \ '\\': { 'left': "\ue0b8", 'right': "\ue0be" },
                \ '\/': { 'left': "\ue0b8", 'right': "\ue0ba" },
                \ '\<': { 'left': "\ue0b8", 'right': "\ue0b2" },
                \ '\(': { 'left': "\ue0b8", 'right': "\ue0b6" },
                \ '//': { 'left': "\ue0bc", 'right': "\ue0ba" },
                \ '/\': { 'left': "\ue0bc", 'right': "\ue0be" },
                \ '/<': { 'left': "\ue0bc", 'right': "\ue0b2" },
                \ '/(': { 'left': "\ue0bc", 'right': "\ue0b6" },
                \ '||': { 'left': '', 'right': '' },
                \ }

    let l:subseparator_styles = {
                \ '><': { 'left': "\ue0b1", 'right': "\ue0b3" },
                \ '>(': { 'left': "\ue0b1", 'right': "\ue0b7" },
                \ '>\': { 'left': "\ue0b1", 'right': "\ue0b9" },
                \ '>/': { 'left': "\ue0b1", 'right': "\ue0bb" },
                \ ')(': { 'left': "\ue0b5", 'right': "\ue0b7" },
                \ ')<': { 'left': "\ue0b5", 'right': "\ue0b1" },
                \ ')\': { 'left': "\ue0b5", 'right': "\ue0b9" },
                \ ')/': { 'left': "\ue0b5", 'right': "\ue0bb" },
                \ '\\': { 'left': "\ue0b9", 'right': "\ue0b9" },
                \ '\/': { 'left': "\ue0b9", 'right': "\ue0bb" },
                \ '\<': { 'left': "\ue0b9", 'right': "\ue0b3" },
                \ '\(': { 'left': "\ue0b9", 'right': "\ue0b7" },
                \ '//': { 'left': "\ue0bb", 'right': "\ue0bb" },
                \ '/\': { 'left': "\ue0bd", 'right': "\ue0b9" },
                \ '/<': { 'left': "\ue0bb", 'right': "\ue0b3" },
                \ '/(': { 'left': "\ue0bb", 'right': "\ue0b7" },
                \ '||': { 'left': '|', 'right': '|' },
                \ }

    call extend(l:separator_styles, {
                \ 'default': copy(l:separator_styles['><']),
                \ 'angle':   copy(l:separator_styles['><']),
                \ 'curvy':   copy(l:separator_styles[')(']),
                \ 'slant':   copy(l:separator_styles['//']),
                \ })

    call extend(l:subseparator_styles, {
                \ 'default': copy(l:subseparator_styles['><']),
                \ 'angle':   copy(l:subseparator_styles['><']),
                \ 'curvy':   copy(l:subseparator_styles[')(']),
                \ 'slant':   copy(l:subseparator_styles['//']),
                \ })

    let g:crystalline_separator_styles = {}

    for [l:style, l:separator] in items(l:separator_styles)
        let l:subseparator = l:subseparator_styles[l:style]
        let g:crystalline_separator_styles[l:style] = [
                    \ { 'ch': l:separator['left'],  'alt_ch': l:subseparator['left'],  'dir': '>' },
                    \ { 'ch': l:separator['right'], 'alt_ch': l:subseparator['right'], 'dir': '<' },
                    \ ]
    endfor
endfunction

function! crystalline_settings#powerline#SetSeparators(style) abort
    call s:InitPowerlineStyles()

    let l:style = 'default'

    if type(a:style) == v:t_string && strlen(a:style)
        let l:style = a:style
    endif

    if l:style ==? 'random'
        let l:rand = str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:])
        let l:style = keys(g:crystalline_separator_styles)[l:rand % len(g:crystalline_separator_styles)]
    endif

    let g:crystalline_separators = deepcopy(get(g:crystalline_separator_styles, l:style, g:crystalline_separator_styles['default']))
    let g:crystalline_symbols = extend(g:crystalline_symbols, {
            \ 'left':      g:crystalline_separators[0].ch,
            \ 'right':     g:crystalline_separators[1].ch,
            \ 'left_sep':  g:crystalline_separators[0].alt_ch,
            \ 'right_sep': g:crystalline_separators[1].alt_ch,
            \ })
endfunction
