let s:crystalline_ctrlp = {}

" TODO: Move these variables and functions to autload and reuse them
let s:symbols = {
            \ 'left':      g:crystalline_separators[0].ch,
            \ 'right':     g:crystalline_separators[1].ch,
            \ 'left_sep':  ' ' . g:crystalline_separators[0].alt_ch . ' ',
            \ 'right_sep': ' ' . g:crystalline_separators[1].alt_ch . ' ',
            \ }

function! s:RemoveEmptyElement(list) abort
    return filter(copy(a:list), '!empty(v:val)')
endfunction

function! s:EnsureList(list) abort
    return type(a:list) == type([]) ? deepcopy(a:list) : [a:list]
endfunction

function! s:ParseList(list, sep) abort
    let l:list = s:EnsureList(a:list)
    let l:list = map(copy(l:list), "type(v:val) == type([]) ? join(s:RemoveEmptyElement(v:val), a:sep) : v:val")
    return s:RemoveEmptyElement(l:list)
endfunction

function! s:BuildMode(parts, ...) abort
    let sep = get(a:, 1, s:symbols.left_sep)
    let l:parts = s:ParseList(a:parts, l:sep)
    return join(l:parts, l:sep)
endfunction

function! s:BuildRightMode(parts) abort
    return s:BuildMode(a:parts, s:symbols.right_sep)
endfunction

function! s:BuildFill(parts, ...) abort
    let sep = get(a:, 1, s:symbols.left_sep)
    let l:parts = s:ParseList(a:parts, sep)
    return join(l:parts, sep)
endfunction

function! s:BuildRightFill(parts, ...) abort
    return s:BuildFill(a:parts, s:symbols.right_sep)
endfunction

function! s:GetCurrentDir() abort
    let dir = fnamemodify(getcwd(), ':~:.')
    if empty(dir)
        let dir = getcwd()
    endif
    return dir
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
                \ 'rmode': s:crystalline_ctrlp.dir,
                \ }

    if s:crystalline_ctrlp.main
        let lfill = s:BuildFill([
                    \ s:crystalline_ctrlp.prev,
                    \ printf(' %s %s %s ', '«', s:crystalline_ctrlp.item, '»'),
                    \ s:crystalline_ctrlp.next,
                    \ ])

        let rfill = s:BuildRightFill([
                    \ s:crystalline_ctrlp.focus,
                    \ s:crystalline_ctrlp.byfname,
                    \ ])

        call extend(result, {
                \ 'lfill': lfill,
                \ 'rfill': rfill,
                \ })
    else
        call extend(result, {
                    \ 'lfill': s:crystalline_ctrlp.len,
                    \ })
    endif

    return result
endfunction
