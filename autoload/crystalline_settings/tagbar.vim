let s:crystalline_tagbar = {}

function! crystalline_settings#tagbar#Status(current, sort, fname, flags, ...) abort
    let s:crystalline_tagbar.sort  = a:sort
    let s:crystalline_tagbar.fname = a:fname
    let s:crystalline_tagbar.flags = a:flags
    return crystalline#GetStatusline(a:current ? win_getid() : 0)
endfunction

function! crystalline_settings#tagbar#Mode(...) abort
    if empty(s:crystalline_tagbar.flags)
        let l:flags = ''
    else
        let l:flags = '[' .. join(s:crystalline_tagbar.flags, '') .. ']'
    endif

    return {
                \ 'section_a': s:crystalline_tagbar.sort,
                \ 'section_b': l:flags,
                \ 'section_c': s:crystalline_tagbar.fname,
                \ }
endfunction
