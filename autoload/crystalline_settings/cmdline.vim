vim9script

export def Mode(...args: list<any>): dict<any>
    return {
        section_a: 'Command Line',
        section_b: crystalline_settings#Concatenate([
            '<C-C>: edit',
            '<CR>: execute',
        ], 0),
        section_x: crystalline_settings#lineinfo#Simple(),
    }
enddef
