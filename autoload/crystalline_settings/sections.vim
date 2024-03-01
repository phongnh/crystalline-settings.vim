function! crystalline_settings#sections#Mode(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return l:mode['name']
    endif

    return crystalline_settings#Concatenate([
                \ crystalline_settings#parts#Mode(),
                \ crystalline_settings#parts#Clipboard(),
                \ crystalline_settings#parts#Paste(),
                \ crystalline_settings#parts#Spell(),
                \ ])
endfunction

function! crystalline_settings#sections#Plugin(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'lfill', '')
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if g:crystalline_show_git_branch && l:winwidth >= g:crystalline_winwidth_config.small
        return crystalline_settings#Concatenate([
                    \ crystalline_settings#git#Branch(l:winwidth),
                    \ crystalline_settings#parts#FileName(l:winwidth - 2),
                    \ ])
    endif

    return crystalline_settings#parts#FileName(l:winwidth - 2)
endfunction

function! crystalline_settings#sections#FileName(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'lextra', '')
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth >= g:crystalline_winwidth_config.small
    endif

    return ''
endfunction

function! crystalline_settings#sections#Buffer(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'rmode', '')
    endif

    let l:winnr = get(a:, 1, 0)
    return crystalline_settings#parts#FileInfo(l:winnr)
endfunction

function! crystalline_settings#sections#Settings(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'rfill', '')
    endif

    let l:winnr = get(a:, 1, 0)
    let l:compact = crystalline_settings#IsCompact(l:winnr)
    return crystalline_settings#Concatenate([
                \ crystalline_settings#parts#Indentation(l:compact),
                \ crystalline_settings#parts#FileEncodingAndFormat(),
                \ ], 1)
endfunction

function! crystalline_settings#sections#Info(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'rextra', '')
    endif

    return ''
endfunction

function! crystalline_settings#sections#InactiveMode(...) abort
    " Show only custom mode in inactive buffer
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return crystalline_settings#Concatenate([
                    \ l:mode['name'],
                    \ get(l:mode, 'lfill_inactive', ''),
                    \ ])
    endif

    " plugin/statusline.vim[+]
    return crystalline_settings#parts#InactiveFileName()
endfunction
