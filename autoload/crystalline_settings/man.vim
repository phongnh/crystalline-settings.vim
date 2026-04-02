function! crystalline_settings#man#Statusline(...) abort
    return {
                \ 'section_a': 'MAN',
                \ 'section_b': expand('%:t'),
                \ 'section_x': crystalline_settings#components#Ruler(),
                \ }
endfunction
