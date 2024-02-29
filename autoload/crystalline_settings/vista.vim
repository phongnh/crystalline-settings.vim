" https://github.com/liuchengxu/vista.vim
function! crystalline_settings#vista#Mode(...) abort
    let provider = get(get(g:, 'vista', {}), 'provider', '')
    return {
                \ 'lfill': provider,
                \ 'lfill_inactive': provider,
                \ }
endfunction
