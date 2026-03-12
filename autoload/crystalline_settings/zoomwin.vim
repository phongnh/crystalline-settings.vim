function! crystalline_settings#zoomwin#Status(zoomstate) abort
    for l:F in g:crystalline_zoomwin_funcref
        if type(l:F) == v:t_func && l:F != function('crystalline_settings#zoomwin#Status')
            call l:F(a:zoomstate)
        endif
    endfor
    let g:crystalline_zoomed = a:zoomstate
endfunction
