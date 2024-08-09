function! crystalline_settings#Trim(str) abort
    return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

if exists('*trim')
    function! crystalline_settings#Trim(str) abort
        return trim(a:str)
    endfunction
endif

function! crystalline_settings#ShortenPath(filename) abort
    return substitute(a:filename, '\v\w\zs.{-}\ze(\\|/)', '', 'g')
endfunction

if exists('*pathshorten')
    function! crystalline_settings#ShortenPath(filename) abort
        return pathshorten(a:filename)
    endfunction
endif

function! crystalline_settings#FormatFileName(fname, winwidth, max_width) abort
    let fname = a:fname

    if a:winwidth < g:crystalline_winwidth_config.default
        return fnamemodify(fname, ':t')
    endif

    if strlen(fname) > a:winwidth && (fname[0] =~ '\~\|/') && g:crystalline_shorten_path
        let fname = crystalline_settings#ShortenPath(fname)
    endif

    let max_width = min([a:winwidth, a:max_width])

    if strlen(fname) > max_width
        let fname = fnamemodify(fname, ':t')
    endif

    return fname
endfunction

function! crystalline_settings#Group(exp) abort
    if a:exp =~ '^%'
        return '%( ' . a:exp . ' %)'
    else
        return '%( %{' . a:exp . '} %)'
    endif
endfunction

function! crystalline_settings#Concatenate(parts, ...) abort
    let separator = get(a:, 1, 0) ? g:crystalline_symbols.right_sep : g:crystalline_symbols.left_sep
    return join(filter(copy(a:parts), 'v:val !=# ""'), ' ' . separator . ' ')
endfunction

function! crystalline_settings#Init() abort
    setglobal noshowmode laststatus=2

    " Disable NERDTree statusline
    let g:NERDTreeStatusline = -1

    " CtrlP Integration
    if exists(':CtrlP') == 2
        let g:ctrlp_status_func = {
                    \ 'main': 'crystalline_settings#ctrlp#MainStatus',
                    \ 'prog': 'crystalline_settings#ctrlp#ProgressStatus',
                    \ }
    endif

    " Tagbar Integration
    if exists(':Tagbar') == 2
        let g:tagbar_status_func = 'crystalline_settings#tagbar#Status'
    endif

    if exists(':ZoomWin') == 2
        let g:crystalline_zoomwin_funcref = []

        if exists('g:ZoomWin_funcref')
            if type(g:ZoomWin_funcref) == v:t_func
                let g:crystalline_zoomwin_funcref = [g:ZoomWin_funcref]
            elseif type(g:ZoomWin_funcref) == v:t_func
                let g:crystalline_zoomwin_funcref = g:ZoomWin_funcref
            endif
            let g:crystalline_zoomwin_funcref = uniq(copy(g:crystalline_zoomwin_funcref))
        endif

        let g:ZoomWin_funcref = function('crystalline_settings#zoomwin#Status')
    endif
endfunction
