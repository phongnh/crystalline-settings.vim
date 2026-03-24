" https://github.com/ctrlpvim/ctrlp.vim
let s:crystalline_ctrlp = {}

function! s:GetCurrentDir() abort
    let l:cwd = getcwd()
    let l:dir = fnamemodify(l:cwd, ':~:.')
    let l:dir = empty(l:dir) ? l:cwd : l:dir
    return strlen(l:dir) > 30 ? crystalline_settings#ShortenPath(l:dir) : l:dir
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
    let l:result = {
                \ 'section_a': 'CtrlP',
                \ 'section_z': s:crystalline_ctrlp.dir,
                \ }

    if s:crystalline_ctrlp.main
        call extend(l:result, {
                    \ 'section_b': crystalline_settings#Concatenate([
                    \   s:crystalline_ctrlp.prev,
                    \   '« ' .. s:crystalline_ctrlp.item .. ' »',
                    \   s:crystalline_ctrlp.next,
                    \ ], 0),
                    \ 'section_y': crystalline_settings#Concatenate([
                    \   s:crystalline_ctrlp.focus,
                    \   s:crystalline_ctrlp.byfname,
                    \ ], 1)
                    \ })
    else
        call extend(l:result, {
                    \ 'section_y': s:crystalline_ctrlp.len,
                    \ })
    endif

    return l:result
endfunction
