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
        return get(l:mode, 'plugin', '')
    endif
    return call('s:RenderPluginSection', a:000)
endfunction

function! s:RenderPluginSection(...) abort
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
        return get(l:mode, 'filename', '')
    endif
    return call('s:RenderFileNameSection', a:000)
endfunction

function! s:RenderFileNameSection(...) abort
    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth >= g:crystalline_winwidth_config.small
    endif

    return ''
endfunction

function! crystalline_settings#sections#Buffer(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'buffer', '')
    endif
    return call('s:RenderBufferSection', a:000)
endfunction

function! s:RenderBufferSection(...) abort
    return crystalline_settings#parts#FileType()
endfunction

function! crystalline_settings#sections#Settings(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'settings', '')
    endif
    return call('s:RenderSettingsSection', a:000)
endfunction

function! s:RenderSettingsSection(...) abort
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
        return get(l:mode, 'info', '')
    endif
    return call('s:RenderInfoSection', a:000)
endfunction

function! s:RenderInfoSection(...) abort
    return ''
endfunction

function! crystalline_settings#sections#InactiveMode(...) abort
    " Show only custom mode in inactive buffer
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return crystalline_settings#Concatenate([
                    \ l:mode['name'],
                    \ get(l:mode, 'plugin', ''),
                    \ get(l:mode, 'filename', ''),
                    \ ])
    endif
    return call('s:RenderInactiveModeSection', a:000)
endfunction

function! s:RenderInactiveModeSection(...) abort
    " plugin/statusline.vim[+]
    return crystalline_settings#parts#InactiveFileName()
endfunction
