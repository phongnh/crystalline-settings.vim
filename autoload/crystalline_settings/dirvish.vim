" https://github.com/justinmk/vim-dirvish
function! crystalline_settings#dirvish#Mode(...) abort
    return { 'lfill': expand('%:p:~:h') }
endfunction
