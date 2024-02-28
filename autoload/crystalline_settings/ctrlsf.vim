function! crystalline_settings#ctrlsf#Mode() abort
    let pattern = substitute(ctrlsf#utils#SectionB(), 'Pattern: ', '', '')

    return {
                \ 'lfill': pattern,
                \ 'lfill_inactive': pattern,
                \ 'lextra': ctrlsf#utils#SectionC(),
                \ 'rmode': ctrlsf#utils#SectionX(),
                \ }
endfunction

function! crystalline_settings#ctrlsf#PreviewMode() abort
    let stl = ctrlsf#utils#PreviewSectionC()
    return {
                \ 'lfill': stl,
                \ 'lfill_inactive': stl,
                \ }
endfunction
