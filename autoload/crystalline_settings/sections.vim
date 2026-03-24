vim9script

export def SectionA(...args: list<any>): string
    const integration = crystalline_settings#components#Integration()
    if !empty(integration)
        return integration['section_a']
    endif

    return crystalline_settings#Concatenate([
        crystalline_settings#components#Mode(),
        crystalline_settings#components#Clipboard(),
        crystalline_settings#components#Paste(),
    ], 0)
enddef

export def SectionB(...args: list<any>): string
    const integration = crystalline_settings#components#Integration()
    if !empty(integration)
        return get(integration, 'section_b', '')
    endif

    const winwidth = crystalline_settings#GetWinWidth(get(args, 0, 0))
    if winwidth >= g:crystalline_winwidth_config.default
        return crystalline_settings#components#GitBranch(winwidth)
    endif

    return ''
enddef

export def SectionC(...args: list<any>): string
    const integration = crystalline_settings#components#Integration()
    if !empty(integration)
        return get(integration, 'section_c', '')
    endif

    const winwidth = crystalline_settings#GetWinWidth(get(args, 0, 0))
    return crystalline_settings#components#FileName(winwidth - 2)
enddef

export def SectionX(...args: list<any>): string
    const integration = crystalline_settings#components#Integration()
    if !empty(integration)
        return get(integration, 'section_x', '')
    endif

    const winnr = get(args, 0, 0)
    if crystalline_settings#GetWinWidth(winnr) <= g:crystalline_winwidth_config.compact
        return ''
    endif

    if g:crystalline_show_linenr > 1
        return crystalline_settings#components#Ruler()
    elseif g:crystalline_show_linenr > 0
        return crystalline_settings#components#Position()
    endif
    return ''
enddef

export def SectionY(...args: list<any>): string
    const integration = crystalline_settings#components#Integration()
    if !empty(integration)
        return get(integration, 'section_y', '')
    endif

    return crystalline_settings#Concatenate([
        crystalline_settings#components#Spell(),
        crystalline_settings#components#Indentation(),
        crystalline_settings#components#FileEncodingAndFormat(),
    ], 1)
enddef

export def SectionZ(...args: list<any>): string
    const integration = crystalline_settings#components#Integration()
    if !empty(integration)
        return get(integration, 'section_z', '')
    endif

    return crystalline_settings#components#FileType()
enddef

export def InactiveSectionA(...args: list<any>): string
    # Show only custom mode in inactive buffer
    const integration = crystalline_settings#components#Integration()
    if !empty(integration)
        return crystalline_settings#Concatenate([
            integration['section_a'],
            get(integration, 'section_b', ''),
            get(integration, 'section_c', ''),
        ], 0)
    endif

    # plugin/statusline.vim[+]
    return crystalline_settings#components#InactiveFileName()
enddef
