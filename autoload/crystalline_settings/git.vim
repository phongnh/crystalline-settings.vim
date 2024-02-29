" Caching
let s:crystalline_time_threshold = 0.50
let s:crystalline_last_finding_branch_time = reltime()

function! s:GetGitBranch() abort
    " Get branch from caching if it is available
    if has_key(b:, 'crystalline_git_branch') && reltimefloat(reltime(s:crystalline_last_finding_branch_time)) < s:crystalline_time_threshold
        return b:crystalline_git_branch
    endif

    let branch = ''

    if exists('*FugitiveHead')
        let branch = FugitiveHead()

        if empty(branch) && exists('*FugitiveDetect') && !exists('b:git_dir')
            call FugitiveDetect(getcwd())
            let branch = FugitiveHead()
        endif
    elseif exists('*fugitive#head')
        let branch = fugitive#head()

        if empty(branch) && exists('*fugitive#detect') && !exists('b:git_dir')
            call fugitive#detect(getcwd())
            let branch = fugitive#head()
        endif
    elseif exists(':Gina') == 2
        let branch = gina#component#repo#branch()
    endif

    " Caching
    let b:crystalline_git_branch = branch
    let s:crystalline_last_finding_branch_time = reltime()

    return branch
endfunction

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

    let branch = s:ShortenBranch(a:branch, 30)

    if strlen(branch) > 30
        let branch = strcharpart(branch, 0, 29) . g:crystalline_symbols.ellipsis
    endif

    return branch
endfunction

function! crystalline_settings#git#Branch(...) abort
    let branch = s:FormatBranch(s:GetGitBranch(), get(a:, 1, winwidth(0)))

    if strlen(branch)
        return g:crystalline_symbols.branch . ' ' . branch
    endif

    return branch
endfunction
