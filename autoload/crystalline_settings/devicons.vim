function! crystalline_settings#devicons#FileType(filename) abort
    return ''
endfunction

function! crystalline_settings#devicons#Detect() abort
    if findfile('autoload/nerdfont.vim', &rtp) != ''
        function! crystalline_settings#devicons#FileType(filename) abort
            return ' ' . nerdfont#find(a:filename) . ' '
        endfunction

        return 1
    elseif findfile('plugin/webdevicons.vim', &rtp) != ''
        function! crystalline_settings#devicons#FileType(filename) abort
            return ' ' . WebDevIconsGetFileTypeSymbol(a:filename) . ' '
        endfunction

        return 1
    elseif exists("g:CrystallineWebDevIconsFind")
        function! crystalline_settings#devicons#FileType(filename) abort
            return ' ' . g:CrystallineWebDevIconsFind(a:filename) . ' '
        endfunction

        return 1
    endif

    return 0
endfunction
