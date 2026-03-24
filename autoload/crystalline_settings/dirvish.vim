" https://github.com/justinmk/vim-dirvish
function! crystalline_settings#dirvish#Mode(...) abort
    return { 'section_a': 'Dirvish', 'section_c': expand('%:p:~:.:h') }
endfunction
