vim9script

export def Status(zoomstate: any)
    var Z = function('crystalline_settings#zoomwin#Status')
    for F in g:crystalline_zoomwin_funcref
        if type(F) == v:t_func && F != Z
            call(F, [zoomstate])
        endif
    endfor
    g:crystalline_zoomstate = zoomstate
enddef
