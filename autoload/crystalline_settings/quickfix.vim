function! crystalline_settings#quickfix#Statusline(...) abort
    return {
                \ 'section_a': getwininfo(win_getid())[0]['loclist'] ? 'Location' : 'Quickfix',
                \ 'section_b': crystalline_settings#Trim(get(w:, 'quickfix_title', '')),
                \ }
endfunction
