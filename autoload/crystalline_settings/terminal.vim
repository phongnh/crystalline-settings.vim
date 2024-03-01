function! crystalline_settings#terminal#Mode(...) abort
    return { 'name': 'TERMINAL', 'plugin': expand('%') }
endfunction
