" Caching - increased threshold for better performance
let s:crystalline_time_threshold = 2.0
let s:crystalline_cache = {}
let s:crystalline_fugitive_detected = {}

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
    let l:bufnr = bufnr('%')
    let l:cwd = getcwd()
    let l:cache_key = l:bufnr . ':' . l:cwd
    
    " Check cache with timestamp
    if has_key(s:crystalline_cache, l:cache_key)
        let l:cache_entry = s:crystalline_cache[l:cache_key]
        if reltimefloat(reltime(l:cache_entry.time)) < s:crystalline_time_threshold
            return l:cache_entry.branch
        endif
    endif

    let l:branch = ''

    if exists('*FugitiveHead')
        " Only detect once per buffer+cwd combination
        if !get(s:crystalline_fugitive_detected, l:cache_key, 0) && !exists('b:git_dir')
            call FugitiveDetect(l:cwd)
            let s:crystalline_fugitive_detected[l:cache_key] = 1
        endif
        let l:branch = FugitiveHead()
    elseif exists('*fugitive#head')
        " Only detect once per buffer+cwd combination
        if !get(s:crystalline_fugitive_detected, l:cache_key, 0) && !exists('b:git_dir')
            call fugitive#detect(l:cwd)
            let s:crystalline_fugitive_detected[l:cache_key] = 1
        endif
    endif

    " Update cache
    let s:crystalline_cache[l:cache_key] = {
                \ 'branch': l:branch,
                \ 'time': reltime()
                \ }

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

" Clear cache on buffer events to ensure fresh data on branch changes
function! crystalline_settings#git#ClearCache() abort
    let s:crystalline_cache = {}
    let s:crystalline_fugitive_detected = {}
endfunction

" Optionally set up autocmds to clear cache on git operations
" Users can add to their vimrc:
" autocmd User FugitiveChanged call crystalline_settings#git#ClearCache()
" autocmd BufWritePost * call crystalline_settings#git#ClearCache()
