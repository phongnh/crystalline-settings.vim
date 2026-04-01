function! crystalline_settings#sections#SectionA(...) abort
    let l:integration = crystalline_settings#components#Integration()
    if len(l:integration)
        return l:integration['section_a']
    endif

    return crystalline_settings#Concatenate([
                \   crystalline_settings#components#Mode(),
                \   crystalline_settings#components#Clipboard(),
                \   crystalline_settings#components#Paste(),
                \ ], 0)
endfunction

function! crystalline_settings#sections#SectionB(...) abort
    let l:integration = crystalline_settings#components#Integration()
    if len(l:integration)
        return get(l:integration, 'section_b', '')
    endif

    let l:winwidth = crystalline_settings#GetWinWidth(get(a:, 1, 0))
    if g:crystalline_show_git_branch > 0 && l:winwidth >= g:crystalline_winwidth_config.default
        return crystalline_settings#components#Branch()
    endif

    return ''
endfunction

function! crystalline_settings#sections#SectionC(...) abort
    let l:integration = crystalline_settings#components#Integration()
    if len(l:integration)
        return get(l:integration, 'section_c', '')
    endif

    let l:winwidth = crystalline_settings#GetWinWidth(get(a:, 1, 0))
    return crystalline_settings#components#FileName(l:winwidth - 2)
endfunction

function! crystalline_settings#sections#SectionX(...) abort
    let l:integration = crystalline_settings#components#Integration()
    if len(l:integration)
        return get(l:integration, 'section_x', '')
    endif

    let l:winnr = get(a:, 1, 0)
    if crystalline_settings#GetWinWidth(l:winnr) <= g:crystalline_winwidth_config.compact
        return ''
    endif

    if g:crystalline_show_linenr > 1
        return crystalline_settings#components#Ruler()
    elseif g:crystalline_show_linenr > 0
        return crystalline_settings#components#Position()
    endif

    return ''
endfunction

function! crystalline_settings#sections#SectionY(...) abort
    let l:integration = crystalline_settings#components#Integration()
    if len(l:integration)
        return get(l:integration, 'section_y', '')
    endif

    return crystalline_settings#Concatenate([
                \   crystalline_settings#components#Spell(),
                \   crystalline_settings#components#Indentation(),
                \   crystalline_settings#components#FileEncodingAndFormat(),
                \ ], 1)
endfunction

function! crystalline_settings#sections#SectionZ(...) abort
    let l:integration = crystalline_settings#components#Integration()
    if len(l:integration)
        return get(l:integration, 'section_z', '')
    endif

    return crystalline_settings#components#FileType()
endfunction

function! crystalline_settings#sections#InactiveSectionA(...) abort
    " Show only custom mode in inactive buffer
    let l:integration = crystalline_settings#components#Integration()
    if len(l:integration)
        return crystalline_settings#Concatenate([
                    \   l:integration['section_a'],
                    \   get(l:integration, 'section_b', ''),
                    \   get(l:integration, 'section_c', ''),
                    \ ], 0)
    endif

    " plugin/statusline.vim[+]
    return crystalline_settings#components#InactiveFileName()
endfunction
