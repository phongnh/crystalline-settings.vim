" https://github.com/liuchengxu/vista.vim
function! crystalline_settings#vista#Mode(...) abort
    let l:provider = get(get(g:, 'vista', {}), 'provider', '')
    return { 'name': 'Vista', 'plugin': l:provider, '-plugin': l:provider }
endfunction
