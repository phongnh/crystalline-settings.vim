" https://github.com/mbbill/undotree
function! crystalline_settings#undotree#Mode(...) abort
    return {
                \ 'name': 'Undo',
                \ 'plugin': exists('t:undotree') ? t:undotree.GetStatusLine() : '',
                \ }
endfunction

function! crystalline_settings#undotree#DiffStatus(...) abort
    return {
                \ 'name': 'Undo',
                \ 'plugin': exists('t:diffpanel') ? t:diffpanel.GetStatusLine() : '',
                \ }
endfunction
