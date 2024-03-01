" https://github.com/mattn/vim-molder
function! crystalline_settings#molder#Mode(...) abort
    let result = {}

    if exists('b:molder_dir')
        let result['plugin'] = fnamemodify(b:molder_dir, ':p:~:h')
    endif

    return result
endfunction
