if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    finish
endif
let g:loaded_vim_crystalline_settings = 1

let s:save_cpo = &cpo
set cpo&vim

function! CrystallinePasteAndSpell() abort
    let ary = []

    if &paste
        call add(ary, '[PASTE]')
    endif

    if &spell
        call add(ary, '[SPELL]')
    endif

    if len(ary)
        return ' ' . join(ary, ' ') . ' '
    endif

    return ''
endfunction

function! CrystallineFileEncoding() abort
    let encoding = &fenc !=# '' ? &fenc : &enc
    if encoding !=? 'utf-8'
        return '[' . encoding . ']'
    endif
    return ''
endfunction

function! CrystallineFileFormat() abort
    return &ff !=? 'unix' ? '[' . &ff . ']' : ''
endfunction

function! CrystallineSpacesOrTabSize() abort
    let shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    return printf(' %s: %d ', (&expandtab ? 'Spaces' : 'Tab Size'), shiftwidth)
endfunction

function! StatusLine(current, width)
    let l:s = ''

    if a:current
        let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
    else
        let l:s .= '%#CrystallineInactive#'
    endif
    let l:s .= ' %f%h%w%m%r '
    if a:current
        let l:s .= crystalline#right_sep('', 'Fill') . ' %{fugitive#head()}'
    endif

    let l:s .= '%='
    if a:current
        let l:s .= CrystallinePasteAndSpell()
        let l:s .= crystalline#left_sep('', 'Fill')
        let l:s .= CrystallineSpacesOrTabSize()
        let l:s .= crystalline#left_mode_sep('')
    endif

    if a:width > 80
        let l:s .= ' %{&ft}%{CrystallineFileEncoding()}%{CrystallineFileFormat()} '
    else
        let l:s .= ' '
    endif

    return l:s
endfunction

function! TabLine()
    let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
    return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_enable_sep    = get(g:, 'crystalline_powerline', 0)
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn    = 'TabLine'
let g:crystalline_theme         = 'solarized'
