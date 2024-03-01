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

function! StatusLineActiveMode(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return l:mode['name']
    endif

    return crystalline_settings#Concatenate([
                \ crystalline_settings#parts#Mode(),
                \ crystalline_settings#parts#Clipboard(),
                \ crystalline_settings#parts#Paste(),
                \ crystalline_settings#parts#Spell(),
                \ ])
endfunction

function! StatusLineLeftFill(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'lfill', '')
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if g:crystalline_show_git_branch && l:winwidth >= g:crystalline_winwidth_config.small
        return crystalline_settings#Concatenate([
                    \ crystalline_settings#git#Branch(l:winwidth),
                    \ crystalline_settings#parts#FileName(l:winwidth - 2),
                    \ ])
    endif

    return crystalline_settings#parts#FileName(l:winwidth - 2)
endfunction

function! StatusLineLeftExtra(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'lextra', '')
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth >= g:crystalline_winwidth_config.small
    endif

    return ''
endfunction

function! StatusLineRightMode(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'rmode', '')
    endif

    let l:winnr = get(a:, 1, 0)
    return crystalline_settings#parts#FileInfo(l:winnr)
endfunction

function! StatusLineRightFill(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'rfill', '')
    endif

    let l:winnr = winwidth(get(a:, 1, 0))
    let l:compact = crystalline_settings#IsCompact(l:winnr)
    return crystalline_settings#parts#Indentation(l:compact)
endfunction

function! StatusLineRightExtra(...) abort
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return get(l:mode, 'rextra', '')
    endif

    return ''
endfunction

function! StatusLineInactiveMode(...) abort
    " show only custom mode in inactive buffer
    let l:mode = crystalline_settings#parts#Integration()
    if len(l:mode)
        return crystalline_settings#Concatenate([
                    \ l:mode['name'],
                    \ get(l:mode, 'lfill_inactive', ''),
                    \ ])
    endif

    " plugin/statusline.vim[+]
    return crystalline_settings#parts#InactiveFileName()
endfunction

function! g:CrystallineStatuslineFn(winnr) abort
    let l:current = a:winnr == winnr()
    if l:current
        return join([
                    \ '%<',
                    \ crystalline#ModeHiItem('A'),
                    \ crystalline_settings#Group(printf('StatusLineActiveMode(%d)', a:winnr)),
                    \ crystalline#Sep(0, crystalline#ModeSepGroup('A'), 'B'),
                    \ crystalline_settings#Group(printf('StatusLineLeftFill(%d)', a:winnr)),
                    \ crystalline#Sep(0, 'B', 'Fill'),
                    \ crystalline_settings#Group(printf('StatusLineLeftExtra(%d)', a:winnr)),
                    \ '%=',
                    \ '%<',
                    \ crystalline_settings#Group(printf('StatusLineRightExtra(%d)', a:winnr)),
                    \ crystalline#Sep(1, 'Fill', 'B'),
                    \ crystalline_settings#Group(printf('StatusLineRightFill(%d)', a:winnr)),
                    \ crystalline#Sep(1, 'B', 'A'),
                    \ crystalline_settings#Group(printf('StatusLineRightMode(%d)', a:winnr)),
                    \ ], '')
    else
        return crystalline#HiItem('InactiveFill') .
                    \ '%<' .
                    \ crystalline_settings#Group(printf('StatusLineInactiveMode(%d)', a:winnr))
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

    " Get name
    let l:name = bufname(a:buf)
    if l:name ==# ''
        let l:name = g:crystalline_tab_empty
        let l:name_width = strchars(l:name)
    else
        let l:name = printf('%d: %s', a:buf, fnamemodify(l:name, ':t'))
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

augroup CrystallineSettings
    autocmd!
    autocmd VimEnter * call crystalline_settings#Init()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
