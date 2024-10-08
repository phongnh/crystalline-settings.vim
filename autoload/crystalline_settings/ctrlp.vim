" https://github.com/ctrlpvim/ctrlp.vim
let s:crystalline_ctrlp = {}

function! s:GetCurrentDir() abort
    let dir = fnamemodify(getcwd(), ':~:.')
    let dir = empty(dir) ? getcwd() : dir
    return strlen(dir) > 30 ? crystalline_settings#ShortenPath(dir) : dir
endfunction

function! crystalline_settings#ctrlp#MainStatus(focus, byfname, regex, prev, item, next, marked) abort
    let s:crystalline_ctrlp.main    = 1
    let s:crystalline_ctrlp.focus   = a:focus
    let s:crystalline_ctrlp.byfname = a:byfname
    let s:crystalline_ctrlp.regex   = a:regex
    let s:crystalline_ctrlp.prev    = a:prev
    let s:crystalline_ctrlp.item    = a:item
    let s:crystalline_ctrlp.next    = a:next
    let s:crystalline_ctrlp.marked  = a:marked
    let s:crystalline_ctrlp.dir     = s:GetCurrentDir()

    return g:CrystallineStatuslineFn(winnr())
endfunction

function! crystalline_settings#ctrlp#ProgressStatus(len) abort
    let s:crystalline_ctrlp.main = 0
    let s:crystalline_ctrlp.len  = a:len
    let s:crystalline_ctrlp.dir  = s:GetCurrentDir()

    return g:CrystallineStatuslineFn(winnr())
endfunction

function! crystalline_settings#ctrlp#Mode() abort
    let result = {
                \ 'name': 'CtrlP',
                \ 'buffer': s:crystalline_ctrlp.dir,
                \ }

    if s:crystalline_ctrlp.main
        let plugin = crystalline_settings#Concatenate([
                    \ s:crystalline_ctrlp.prev,
                    \ printf('%s %s %s', '«', s:crystalline_ctrlp.item, '»'),
                    \ s:crystalline_ctrlp.next,
                    \ ])

        let settings = crystalline_settings#Concatenate([
                    \ s:crystalline_ctrlp.focus,
                    \ s:crystalline_ctrlp.byfname,
                    \ ], 1)

        call extend(result, {
                \ 'plugin': plugin,
                \ 'settings': settings,
                \ })
    else
        call extend(result, {
                    \ 'settings': s:crystalline_ctrlp.len,
                    \ })
    endif

    return result
endfunction
