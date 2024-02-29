function! crystalline_settings#Strip(str) abort
    return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

if exists('*trim')
    function! crystalline_settings#Strip(str) abort
        return trim(a:str)
    endfunction
endif

function! crystalline_settings#ShortenPath(filename) abort
    return substitute(a:filename, '\v\w\zs.{-}\ze(\\|/)', '', 'g')
endfunction

if exists('*pathshorten')
    function! crystalline_settings#ShortenPath(filename) abort
        return pathshorten(a:filename)
    endfunction
endif

function! crystalline_settings#FormatFileName(fname, winwidth, max_width) abort
    let fname = a:fname

    if a:winwidth < g:crystalline_winwidth_config.small
        return fnamemodify(fname, ':t')
    endif

    if strlen(fname) > a:winwidth && (fname[0] =~ '\~\|/') && g:crystalline_shorten_path
        let fname = crystalline_settings#ShortenPath(fname)
    endif

    let max_width = min([a:winwidth, a:max_width])

    if strlen(fname) > max_width
        let fname = fnamemodify(fname, ':t')
    endif

    return fname
endfunction

function! crystalline_settings#IsClipboardEnabled() abort
    return match(&clipboard, 'unnamed') > -1
endfunction

function! crystalline_settings#IsCompact(winwidth) abort
    return &spell || &paste || crystalline_settings#IsClipboardEnabled() || a:winwidth <= g:crystalline_winwidth_config.xsmall
endfunction
