let s:crystalline_tagbar = {}

function! crystalline_settings#tagbar#Status(current, sort, fname, flags, ...) abort
    let s:crystalline_tagbar.sort  = a:sort
    let s:crystalline_tagbar.fname = a:fname
    let s:crystalline_tagbar.flags = a:flags

    return g:CrystallineStatuslineFn(winnr())
endfunction

function! crystalline_settings#tagbar#Mode(...) abort
    if empty(s:crystalline_tagbar.flags)
        let lextra = ''
    else
        let lextra = printf('[%s]', join(s:crystalline_tagbar.flags, ''))
    endif

    return {
                \ 'name': s:crystalline_tagbar.sort,
                \ 'lfill': s:crystalline_tagbar.fname,
                \ 'lextra': lextra,
                \ 'type': 'tagbar',
                \ }
endfunction
