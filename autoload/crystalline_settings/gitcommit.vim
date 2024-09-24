function! crystalline_settings#gitcommit#Mode(...) abort
    return {
                \ 'name': crystalline_settings#Concatenate([
                \   'Commit Message',
                \   crystalline_settings#parts#Spell(),
                \ ]),
                \ 'plugin': crystalline_settings#git#Branch(),
                \ 'info': crystalline_settings#lineinfo#Simple(),
                \ }
endfunction
