let s:crystalline_tagbar = {}

function! crystalline_settings#tagbar#Status(current, sort, fname, flags, ...) abort
    let s:crystalline_tagbar.sort  = a:sort
    let s:crystalline_tagbar.fname = a:fname
    let s:crystalline_tagbar.flags = a:flags
    return crystalline#GetStatusline(a:current ? win_getid() : 0)
endfunction

function! crystalline_settings#tagbar#Mode(...) abort
    if empty(s:crystalline_tagbar.flags)
        let flags = ''
    else
        let flags = printf('[%s]', join(s:crystalline_tagbar.flags, ''))
    endif

    return {
                \ 'name': s:crystalline_tagbar.sort,
                \ 'plugin': crystalline_settings#Concatenate([s:crystalline_tagbar.fname, flags]),
                \ }
endfunction
