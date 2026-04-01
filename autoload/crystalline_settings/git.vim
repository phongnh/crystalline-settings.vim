function! crystalline_settings#git#Statusline(...) abort
    return {
                \ 'section_a': 'Git',
                \ 'section_c': expand('%:t'),
                \ 'section_x': crystalline_settings#components#Position(),
                \ }
endfunction
