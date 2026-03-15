function! crystalline_settings#zoomwin#Status(zoomstate) abort
    let l:Z = function('crystalline_settings#zoomwin#Status')
    for l:F in g:crystalline_zoomwin_funcref
        if type(l:F) == v:t_func && l:F != l:Z
            call l:F(a:zoomstate)
        endif
    endfor
    let b:crystalline_zoomstate = a:zoomstate
endfunction
