" https://github.com/liuchengxu/vista.vim
function! crystalline_settings#vista#Mode(...) abort
    let l:provider = get(get(g:, 'vista', {}), 'provider', '')
    return { 'section_a': 'Vista', 'section_b': l:provider }
endfunction
