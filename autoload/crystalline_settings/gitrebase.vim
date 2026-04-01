vim9script

export def Statusline(...args: list<any>): dict<any>
    return {
        section_a: 'Git Rebase',
        section_b: crystalline_settings#gitbranch#Component(),
        section_x: crystalline_settings#components#Position(),
        section_y: crystalline_settings#components#Spell(),
    }
enddef
