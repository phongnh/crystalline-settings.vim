function! crystalline_settings#help#Mode(...) abort
    return {
                \ 'name': 'HELP',
                \ 'plugin': expand('%:~:.'),
                \ 'info': crystalline_settings#lineinfo#Full(),
                \ }
endfunction
