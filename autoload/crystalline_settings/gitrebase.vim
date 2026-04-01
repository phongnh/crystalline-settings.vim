function! crystalline_settings#gitrebase#Mode(...) abort
    return {
                \ 'section_a': 'Git Rebase',
                \ 'section_b': crystalline_settings#gitbranch#Name(),
                \ 'section_x': crystalline_settings#lineinfo#Simple(),
                \ 'section_y': crystalline_settings#parts#Spell(),
                \ }
endfunction
