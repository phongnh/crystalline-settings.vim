function! crystalline_settings#quickfix#Mode(...) abort
    let result = { 'name': 'Quickfix' }
    if getwininfo(win_getid())[0]['loclist']
        let result['name'] = 'Location'
    endif
    let qf_title = crystalline_settings#Trim(get(w:, 'quickfix_title', ''))
    return extend(result, {
                \ 'lfill': qf_title,
                \ 'lfill_inactive': qf_title,
                \ })
endfunction
