" https://github.com/lambdalisue/fern.vim
function! crystalline_settings#fern#Mode(...) abort
    return {
                \ 'name':   get(a:, 1, bufname('%')) =~# '^fern://drawer' ? 'Drawer' : 'Fern',
                \ 'plugin': fnamemodify(b:fern.root._path, ':p:~:.:h'),
                \ }
endfunction
