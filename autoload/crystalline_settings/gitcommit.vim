vim9script

export def Mode(...args: list<any>): dict<any>
    return {
        section_a: 'Commit Message',
        section_b: crystalline_settings#git#Branch(),
        section_x: crystalline_settings#lineinfo#Simple(),
        section_y: crystalline_settings#parts#Spell(),
    }
enddef
