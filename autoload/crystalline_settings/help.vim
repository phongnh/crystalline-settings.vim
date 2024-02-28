function! crystalline_settings#help#Mode(...) abort
    let fname = expand('%:p')
    return {
                \ 'name': 'HELP',
                \ 'lfill': fname,
                \ 'lfill_inactive': fname,
                \ })
endfunction
