function! crystalline_settings#theme#List(...) abort
    return join(s:crystalline_themes, "\n")
endfunction

function! crystalline_settings#theme#Detect() abort
    call crystalline_settings#theme#Init()

    if has('vim_starting') && exists('g:crystalline_theme') && g:crystalline_theme ==# 'default'
        call crystalline_settings#theme#Set()
        if g:crystalline_theme !=# 'default'
            call crystalline#SetTheme(g:crystalline_theme)
        endif
    endif
endfunction

function! crystalline_settings#theme#Set() abort
    let g:crystalline_theme = tolower(substitute(g:colors_name, '[ -]', '_', 'g'))
    if index(s:crystalline_themes, g:crystalline_theme) > -1
        return
    endif

    for [l:pattern, l:theme] in items(g:crystalline_theme_mappings)
        if match(g:crystalline_theme, l:pattern) > -1 && index(s:crystalline_themes, l:theme) > -1
            let g:crystalline_theme = l:theme
            return
        endif
    endfor

    let g:crystalline_theme = 'default'
endfunction

function! crystalline_settings#theme#Init() abort
    if !exists('s:crystalline_themes')
        let s:crystalline_themes = map(split(globpath(&rtp, 'autoload/crystalline/theme/*.vim')), "fnamemodify(v:val, ':t:r')")
    endif
endfunction
