vim9script

var crystalline_tagbar = {}

export def Status(current: bool, sort: string, fname: string, flags: list<string>, ...args: list<any>): string
    crystalline_tagbar.sort  = sort
    crystalline_tagbar.fname = fname
    crystalline_tagbar.flags = flags
    return crystalline#GetStatusline(current ? win_getid() : 0)
enddef

export def Mode(...args: list<any>): dict<any>
    var flags = ''
    if !empty(crystalline_tagbar.flags)
        flags = '[' .. join(crystalline_tagbar.flags, '') .. ']'
    endif

    return {
        section_a: crystalline_tagbar.sort,
        section_b: flags,
        section_c: crystalline_tagbar.fname,
    }
enddef
