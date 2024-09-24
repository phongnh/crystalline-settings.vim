" https://github.com/dyng/ctrlsf.vim
function! crystalline_settings#ctrlsf#Mode() abort
    return {
                \ 'plugin':   substitute(ctrlsf#utils#SectionB(), 'Pattern: ', '', ''),
                \ 'filename': fnamemodify(ctrlsf#utils#SectionC(), ':p:~:.'),
                \ 'buffer':   ctrlsf#utils#SectionX(),
                \ }
endfunction

function! crystalline_settings#ctrlsf#PreviewMode() abort
    return { 'filename': fnamemodify(ctrlsf#utils#PreviewSectionC(), ':~:.') }
endfunction
