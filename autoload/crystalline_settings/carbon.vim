" https://github.com/SidOfc/carbon.nvim
function! crystalline_settings#carbon#Statusline(...) abort
    return { 'section_a': 'Carcon', 'section_c': exists('b:carbon') ? fnamemodify(b:carbon['path'], ':p:~:.:h') : '' }
endfunction
