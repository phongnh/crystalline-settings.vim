vim9script

export def Mode(...args: list<any>): dict<any>
    return {
        section_a: 'MAN',
        section_b: expand('%:t'),
        section_x: crystalline_settings#components#Ruler(),
    }
enddef
