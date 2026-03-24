vim9script

# https://github.com/ctrlpvim/ctrlp.vim
var crystalline_ctrlp: dict<any> = {}

def GetCurrentDir(): string
    var cwd = getcwd()
    var dir = fnamemodify(cwd, ':~:.')
    dir = empty(dir) ? cwd : dir
    return strlen(dir) > 30 ? pathshorten(dir) : dir
enddef

export def MainStatus(focus: string, byfname: string, regex: string, prev: string, item: string, next: string, marked: string): string
    crystalline_ctrlp.main    = true
    crystalline_ctrlp.focus   = focus
    crystalline_ctrlp.byfname = byfname
    crystalline_ctrlp.regex   = regex
    crystalline_ctrlp.prev    = prev
    crystalline_ctrlp.item    = item
    crystalline_ctrlp.next    = next
    crystalline_ctrlp.marked  = marked
    crystalline_ctrlp.dir     = GetCurrentDir()

    return call('g:CrystallineStatuslineFn', [winnr()])
enddef

export def ProgressStatus(len: string): string
    crystalline_ctrlp.main = false
    crystalline_ctrlp.len  = len
    crystalline_ctrlp.dir  = GetCurrentDir()

    return call('g:CrystallineStatuslineFn', [winnr()])
enddef

export def Mode(...args: list<any>): dict<any>
    var result = {
        section_a: 'CtrlP',
        section_z: crystalline_ctrlp.dir,
    }

    if crystalline_ctrlp.main
        extend(result, {
            section_b: crystalline_settings#Concatenate([
                crystalline_ctrlp.prev,
                '« ' .. crystalline_ctrlp.item .. ' »',
                crystalline_ctrlp.next,
            ], 0),
            section_y: crystalline_settings#Concatenate([
                crystalline_ctrlp.focus,
                crystalline_ctrlp.byfname,
            ], 1)
        })
    else
        extend(result, {
            section_y: crystalline_ctrlp.len,
        })
    endif

    return result
enddef
