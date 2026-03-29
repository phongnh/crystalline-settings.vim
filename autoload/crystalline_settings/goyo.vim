vim9script

export def OnEnter()
    crystalline#ClearStatusline()
    &l:statusline = ' '
enddef

export def OnLeave()
    crystalline#InitStatusline()
enddef
