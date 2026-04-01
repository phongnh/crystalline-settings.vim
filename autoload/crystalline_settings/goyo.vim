function! crystalline_settings#goyo#OnEnter() abort
    call crystalline#ClearStatusline()
    let &l:statusline = ' '
endfunction

function! crystalline_settings#goyo#OnLeave() abort
    call crystalline#InitStatusline()
endfunction
