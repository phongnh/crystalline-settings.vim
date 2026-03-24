vim9script

export def Mode(...args: list<any>): dict<any>
    return {
        section_a: 'HELP',
        section_c: expand('%:~:.'),
        section_x: crystalline_settings#lineinfo#Full(),
    }
enddef
