function! crystalline_settings#devicons#FileType(filename) abort
    return ''
endfunction

function! crystalline_settings#devicons#Detect() abort
    if !empty(findfile('autoload/nerdfont.vim', &rtp))
        function! crystalline_settings#devicons#FileType(filename) abort
            return ' ' .. nerdfont#find(a:filename, 0) .. ' '
        endfunction

        return 1
    elseif !empty(findfile('plugin/webdevicons.vim', &rtp)) || !empty(findfile('plugin/SupraIcons.vim', &rtp))
        function! crystalline_settings#devicons#FileType(filename) abort
            return ' ' .. WebDevIconsGetFileTypeSymbol(a:filename, 0) .. ' '
        endfunction

        return 1
    endif

    return 0
endfunction
