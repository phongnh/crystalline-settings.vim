" crystalline_settings.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    finish
endif

let g:loaded_vim_crystalline_settings = 1

let s:save_cpo = &cpo
set cpo&vim

call crystalline_settings#Setup()

function! g:CrystallineStatuslineFn(winnr) abort
    let g:crystalline_group_suffix = g:GroupSuffix()
    let l:current = a:winnr == winnr()
    if l:current
        return join([
                    \ '%<',
                    \ crystalline#ModeHiItem('A'),
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#Mode(%d)', a:winnr)),
                    \ crystalline#Sep(0, crystalline#ModeSepGroup('A'), 'B'),
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#Plugin(%d)', a:winnr)),
                    \ crystalline#Sep(0, 'B', 'Fill'),
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#FileName(%d)', a:winnr)),
                    \ '%=',
                    \ '%<',
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#Info(%d)', a:winnr)),
                    \ crystalline#Sep(1, 'Fill', 'B'),
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#Settings(%d)', a:winnr)),
                    \ crystalline#Sep(1, 'B', 'A'),
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#Buffer(%d)', a:winnr)),
                    \ ], '')
    else
        return crystalline#HiItem('InactiveFill') .
                    \ '%<' .
                    \ crystalline_settings#Group(printf('crystalline_settings#sections#InactiveMode(%d)', a:winnr))
    endif
endfunction

function! g:GroupSuffix()
    if mode() ==# 'i' && &paste
        return '2'
    endif
    if &modified
        return '1'
    endif
    return ''
endfunction

function! g:CrystallineTabFn(tab, buf, max_width, is_sel) abort
    " Return early
    if a:max_width <= 0
        return ['', 0]
    endif

    " Get left/right components
    let l:left = g:crystalline_tab_left
    let l:right = getbufvar(a:buf, '&mod') ? g:crystalline_tab_mod : g:crystalline_tab_nomod
    let l:lr_width = strchars(l:left) + strchars(l:right)
    let l:max_name_width = a:max_width - l:lr_width

    let l:nr = crystalline#DefaultTablineIsBuffers() ? a:buf : a:tab

    " Get name
    let l:name = bufname(a:buf)
    if l:name ==# ''
        let l:name = printf('%d: %s', l:nr, g:crystalline_tab_empty)
        let l:name_width = strchars(l:name)
    else
        let l:name = printf('%d: %s', l:nr, fnamemodify(l:name, ':t'))
        let l:name_width = strchars(l:name)
    endif

    " Shorten tab
    if l:max_name_width <= 0
        let l:tab = strcharpart(l:name, l:name_width - a:max_width)
        let l:tabwidth = min([l:name_width, a:max_width])
    else
        let l:tab = l:left . strcharpart(l:name, l:name_width - l:max_name_width) . l:right
        let l:tabwidth = l:lr_width + min([l:name_width, l:max_name_width])
    endif

    return [crystalline#EscapeStatuslineString(l:tab), l:tabwidth]
endfunction


function! g:CrystallineTablineFn()
    let g:crystalline_group_suffix = g:GroupSuffix()
    let l:max_width = &columns

    let l:right = '%='

    let l:right .= crystalline#Sep(1, 'TabFill', 'TabType')
    let l:max_width -= 1

    let l:vimlabel = g:crystalline_vimlabel
    let l:right .= l:vimlabel
    let l:max_width -= strchars(l:vimlabel)

    let l:max_tabs = 10

    return crystalline#DefaultTabline({
                \ 'enable_sep': g:crystalline_enable_sep,
                \ 'max_tabs': l:max_tabs,
                \ 'max_width': l:max_width
                \ }) . l:right
endfunction

augroup CrystallineSettings
    autocmd!
    autocmd User CrystallineSetTheme ++once call crystalline_settings#DetectTheme()
    autocmd ColorScheme * call crystalline_settings#SetTheme()
    autocmd VimEnter * call crystalline_settings#Init()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
