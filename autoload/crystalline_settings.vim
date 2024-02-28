if exists('*pathshorten')
    function! s:ShortenPath(filename) abort
        return pathshorten(a:filename)
    endfunction
else
    function! s:ShortenPath(filename) abort
        return substitute(a:filename, '\v\w\zs.{-}\ze(\\|/)', '', 'g')
    endfunction
endif

function! crystalline_settings#ShortenPath(a:file) abort
    return s:ShortenPath(a:file)
endfunction

function! crystalline_settings#ShortenBranch(branch, length) abort
    let l:branch = a:branch

    if strlen(l:branch) > a:length
        let l:branch = crystalline_settings#ShortenPath(l:branch)
    endif

    if strlen(l:branch) > a:length
        let l:branch = fnamemodify(l:branch, ':t')
    endif

    if strlen(l:branch) > a:length
        " Show only JIRA ticket prefix
        let l:branch = substitute(l:branch, '^\([A-Z]\{3,}-\d\{1,}\)-.\+', '\1', '')
    endif

    return l:branch
endfunction

if exists('*trim')
    function! s:Strip(str) abort
        return trim(a:str)
    endfunction
else
    function! s:Strip(str) abort
        return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
    endfunction
endif

function! crystalline_settings#Strip(str) abort
    return s:Strip(a:str)
endfunction
