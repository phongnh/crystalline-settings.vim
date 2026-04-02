" https://github.com/mbbill/undotree
function! crystalline_settings#undotree#Statusline(...) abort
    return {
                \ 'section_a': 'Undo',
                \ 'section_b': exists('t:undotree') ? t:undotree.GetStatusLine() : '',
                \ }
endfunction
