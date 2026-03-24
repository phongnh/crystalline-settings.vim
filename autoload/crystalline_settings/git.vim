vim9script

export def Mode(...args: list<any>): dict<any>
    return {
        section_a: 'Git',
        section_b: expand('%:t'),
        section_x: crystalline_settings#lineinfo#Simple(),
    }
enddef

export def Branch(): string
    if exists('b:git_dir')
        return call('FugitiveHead', [])
    endif
    return ''
enddef
