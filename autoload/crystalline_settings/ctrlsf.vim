" https://github.com/dyng/ctrlsf.vim
function! crystalline_settings#ctrlsf#Mode() abort
    return {
                \ 'section_a': 'CtrlSF',
                \ 'section_b': substitute(ctrlsf#utils#SectionB(), 'Pattern: ', '', ''),
                \ 'section_c': fnamemodify(ctrlsf#utils#SectionC(), ':p:~:.'),
                \ 'section_z': ctrlsf#utils#SectionX(),
                \ }
endfunction

function! crystalline_settings#ctrlsf#PreviewMode() abort
    return { 'section_a': 'Preview', 'section_c': fnamemodify(ctrlsf#utils#PreviewSectionC(), ':~:.') }
endfunction
