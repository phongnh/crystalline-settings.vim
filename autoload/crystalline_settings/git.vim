" Caching
let s:crystalline_time_threshold = 2.0

function! s:ShortenBranch(branch, length) abort
    let l:len = strlen(a:branch)
    
    " Early exit if already short enough
    if l:len <= a:length
        return a:branch
    endif

    let l:branch = crystalline_settings#ShortenPath(a:branch)
    let l:len = strlen(l:branch)

    if l:len <= a:length
        return l:branch
    endif

    let l:branch = fnamemodify(l:branch, ':t')
    let l:len = strlen(l:branch)

    if l:len <= a:length
        return l:branch
    endif

    " Show only JIRA ticket prefix
    let l:branch = substitute(l:branch, '^\([A-Z]\{3,}-\d\{1,}\)-.\+', '\1', '')
    return l:branch
endfunction

function! s:FormatBranch(branch, winwidth) abort
    if a:winwidth >= g:crystalline_winwidth_config.normal
        return s:ShortenBranch(a:branch, 50)
    endif

    let l:branch = s:ShortenBranch(a:branch, 30)

    if strlen(l:branch) > 30
        let l:branch = strcharpart(l:branch, 0, 29) .. g:crystalline_symbols.ellipsis
    endif

    return l:branch
endfunction

function! s:GetGitBranch() abort
    " Get branch from caching if it is available
    if has_key(b:, 'crystalline_git_branch') && reltimefloat(reltime(get(b:, 'crystalline_last_finding_branch_time', -1))) < s:crystalline_time_threshold
        return b:crystalline_git_branch
    endif

    let l:branch = ''

    if exists('*FugitiveHead')
        let l:branch = FugitiveHead()

        if empty(l:branch) && !exists('b:git_dir')
            call FugitiveDetect()
            let l:branch = FugitiveHead()
        endif
    endif

    " Caching
    let b:crystalline_git_branch = l:branch
    let b:crystalline_last_finding_branch_time = reltime()

    return l:branch
endfunction

function! crystalline_settings#git#Branch(...) abort
    let l:winwidth = get(a:, 1, 0)
    " Use cached winwidth if available and no explicit width passed
    if l:winwidth == 0 && exists('*crystalline_settings#parts#GetWinWidth')
        let l:winwidth = crystalline_settings#parts#GetWinWidth(0)
    elseif l:winwidth == 0
        let l:winwidth = winwidth(0)
    endif

    let l:branch = s:FormatBranch(s:GetGitBranch(), l:winwidth)

    if !empty(l:branch)
        return g:crystalline_symbols.branch .. ' ' .. l:branch
    endif

    return l:branch
endfunction
