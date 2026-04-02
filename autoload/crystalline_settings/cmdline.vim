function! crystalline_settings#cmdline#Statusline(...) abort
    return {
                \ 'section_a': 'Command Line',
                \ 'section_b': crystalline_settings#Concatenate([
                \   '<C-C>: edit',
                \   '<CR>: execute',
                \ ], 0),
                \ 'section_x': crystalline_settings#components#Position(),
                \ }
endfunction
