" https://github.com/justinmk/vim-dirvish
function! crystalline_settings#dirvish#Mode(...) abort
    return { 'name': 'Dirvish', 'plugin': expand('%:p:~:.:h') }
endfunction
