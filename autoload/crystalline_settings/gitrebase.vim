function! crystalline_settings#gitrebase#Statusline(...) abort
    return {
                \ 'section_a': 'Git Rebase',
                \ 'section_b': crystalline_settings#gitbranch#Component(),
                \ 'section_x': crystalline_settings#components#Position(),
                \ 'section_y': crystalline_settings#components#Spell(),
                \ }
endfunction
