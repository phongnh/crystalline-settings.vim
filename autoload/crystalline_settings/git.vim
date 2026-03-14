" Caching
let s:crystalline_time_threshold = 0.50
let s:crystalline_last_finding_branch_time = reltime()

function! s:ShortenBranch(branch, length) abort
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
    if has_key(b:, 'crystalline_git_branch') && reltimefloat(reltime(s:crystalline_last_finding_branch_time)) < s:crystalline_time_threshold
        return b:crystalline_git_branch
    endif

    let l:branch = ''

    if exists('*FugitiveHead')
        let l:branch = FugitiveHead()

        if empty(l:branch) && exists('*FugitiveDetect') && !exists('b:git_dir')
            call FugitiveDetect(getcwd())
            let l:branch = FugitiveHead()
        endif
    elseif exists('*fugitive#head')
        let l:branch = fugitive#head()

        if empty(l:branch) && exists('*fugitive#detect') && !exists('b:git_dir')
            call fugitive#detect(getcwd())
            let l:branch = fugitive#head()
        endif
    elseif exists(':Gina') == 2
        let l:branch = gina#component#repo#branch()
    endif

    " Caching
    let b:crystalline_git_branch = l:branch
    let s:crystalline_last_finding_branch_time = reltime()

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
