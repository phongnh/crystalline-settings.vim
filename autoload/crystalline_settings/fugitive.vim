" https://github.com/tpope/vim-fugitive
function! crystalline_settings#fugitive#Mode(...) abort
    return {
                \ 'plugin': crystalline_settings#git#Branch(),
                \ 'filename': exists('b:fugitive_type') ? b:fugitive_type : '',
                \ }
endfunction
