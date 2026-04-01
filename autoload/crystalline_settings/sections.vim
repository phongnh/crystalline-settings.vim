function! crystalline_settings#sections#SectionA(...) abort
    let l:integration = crystalline_settings#parts#Integration()
    if len(l:integration)
        return l:integration['section_a']
    endif

    return crystalline_settings#Concatenate([
                \   crystalline_settings#parts#Mode(),
                \   crystalline_settings#parts#Clipboard(),
                \   crystalline_settings#parts#Paste(),
                \ ], 0)
endfunction

function! crystalline_settings#sections#SectionB(...) abort
    let l:integration = crystalline_settings#parts#Integration()
    if len(l:integration)
        return get(l:integration, 'section_b', '')
    endif

    let l:winwidth = crystalline_settings#GetWinWidth(get(a:, 1, 0))
    if l:winwidth >= g:crystalline_winwidth_config.default
        return crystalline_settings#parts#GitBranch(l:winwidth)
    endif

    return ''
endfunction

function! crystalline_settings#sections#SectionC(...) abort
    let l:integration = crystalline_settings#parts#Integration()
    if len(l:integration)
        return get(l:integration, 'section_c', '')
    endif

    let l:winwidth = crystalline_settings#GetWinWidth(get(a:, 1, 0))
    return crystalline_settings#parts#FileName(l:winwidth - 2)
endfunction

function! crystalline_settings#sections#SectionX(...) abort
    let l:integration = crystalline_settings#parts#Integration()
    if len(l:integration)
        return get(l:integration, 'section_x', '')
    endif

    let l:winnr = get(a:, 1, 0)
    if crystalline_settings#GetWinWidth(l:winnr) <= g:crystalline_winwidth_config.compact
        return ''
    endif

    return crystalline_settings#parts#LineInfo()
endfunction

function! crystalline_settings#sections#SectionY(...) abort
    let l:integration = crystalline_settings#parts#Integration()
    if len(l:integration)
        return get(l:integration, 'section_y', '')
    endif

    return crystalline_settings#Concatenate([
                \   crystalline_settings#parts#Spell(),
                \   crystalline_settings#parts#Indentation(),
                \   crystalline_settings#parts#FileEncodingAndFormat(),
                \ ], 1)
endfunction

function! crystalline_settings#sections#SectionZ(...) abort
    let l:integration = crystalline_settings#parts#Integration()
    if len(l:integration)
        return get(l:integration, 'section_z', '')
    endif

    return crystalline_settings#parts#FileType()
endfunction

function! crystalline_settings#sections#InactiveSectionA(...) abort
    " Show only custom mode in inactive buffer
    let l:integration = crystalline_settings#parts#Integration()
    if len(l:integration)
        return crystalline_settings#Concatenate([
                    \   l:integration['section_a'],
                    \   get(l:integration, 'section_b', ''),
                    \   get(l:integration, 'section_c', ''),
                    \ ], 0)
    endif

    " plugin/statusline.vim[+]
    return crystalline_settings#parts#InactiveFileName()
endfunction
