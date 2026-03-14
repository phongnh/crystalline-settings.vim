function! crystalline_settings#cmdline#Mode(...) abort
    return {
                \ 'name':   'Command Line',
                \ 'plugin': crystalline_settings#Concatenate([
                \   '<C-C>: edit',
                \   '<CR>: execute',
                \ ], 0),
                \ 'info': crystalline_settings#lineinfo#Simple(),
                \ }
endfunction
