vim9script

export def Mode(...args: list<any>): dict<any>
    return {
        section_a: 'Commit Message',
        section_b: crystalline_settings#gitbranch#Component(),
        section_x: crystalline_settings#components#Position(),
        section_y: crystalline_settings#components#Spell(),
    }
enddef
