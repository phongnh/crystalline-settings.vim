function! crystalline_settings#gitcommit#Statusline(...) abort
    return {
                \ 'section_a': 'Commit Message',
                \ 'section_b': crystalline_settings#gitbranch#Component(),
                \ 'section_x': crystalline_settings#components#Position(),
                \ 'section_y': crystalline_settings#components#Spell(),
                \ }
endfunction
