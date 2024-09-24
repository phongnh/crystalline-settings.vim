" https://github.com/junegunn/gv.vim
function! crystalline_settings#gv#Mode(...) abort
    return {
                \ 'plugin': crystalline#concatenate(
                \   [
                \       'o: open split',
                \       'O: open tab',
                \       'gb: GBrowse',
                \       'q: quit',
                \   ],
                \   0
                \ ),
                \ 'info': crystalline_settings#lineinfo#Simple(),
                \ }
endfunction
