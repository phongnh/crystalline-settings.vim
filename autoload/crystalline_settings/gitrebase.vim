function! crystalline_settings#gitrebase#Mode(...) abort
    return {
                \ 'name': crystalline_settings#Concatenate([
                \   'Git Rebase',
                \   crystalline_settings#parts#Spell(),
                \ ], 0),
                \ 'plugin': crystalline_settings#git#Branch(),
                \ 'info': crystalline_settings#lineinfo#Simple(),
                \ }
endfunction
