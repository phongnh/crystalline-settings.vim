" https://github.com/justinmk/vim-dirvish
function! crystalline_settings#dirvish#Mode(...) abort
    return { 'plugin': expand('%:p:~:h') }
endfunction
