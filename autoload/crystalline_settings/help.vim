function! crystalline_settings#help#Statusline(...) abort
    return {
                \ 'section_a': 'HELP',
                \ 'section_c': expand('%:~:.'),
                \ 'section_x': crystalline_settings#components#Ruler(),
                \ }
endfunction
