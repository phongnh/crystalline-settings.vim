function! crystalline_settings#gitcommit#Mode(...) abort
    return {
                \ 'section_a': 'Commit Message',
                \ 'section_b': crystalline_settings#git#Branch(),
                \ 'section_x': crystalline_settings#lineinfo#Simple(),
                \ 'section_y': crystalline_settings#parts#Spell(),
                \ }
endfunction
