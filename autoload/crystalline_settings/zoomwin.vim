function! crystalline_settings#zoomwin#Status(zoomstate) abort
    for F in g:crystalline_zoomwin_funcref
        if type(F) == v:t_func && F != function('crystalline_settings#zoomwin#Status')
            call F(a:zoomstate)
        endif
    endfor
    let g:crystalline_zoomed = a:zoomstate
endfunction
