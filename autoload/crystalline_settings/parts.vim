function! s:BufferType() abort
    return strlen(&filetype) ? &filetype : &buftype
endfunction

function! s:FileName() abort
    let fname = expand('%')
    return strlen(fname) ? fnamemodify(fname, ':~:.') : '[No Name]'
endfunction

function! s:IsClipboardEnabled() abort
    return match(&clipboard, 'unnamed') > -1
endfunction

function! s:IsCompact(...) abort
    let l:winnr = get(a:, 1, 0)
    return winwidth(l:winnr) <= g:crystalline_winwidth_config.compact ||
                \ count([
                \   s:IsClipboardEnabled(),
                \   &paste,
                \   &spell,
                \   &bomb,
                \   !&eol,
                \ ], 1) > 1
endfunction

function! crystalline_settings#parts#Mode() abort
    if s:IsCompact()
        return crystalline_settings#Trim(get(g:crystalline_short_mode_labels, mode(), ''))
    else
        return crystalline_settings#Trim(crystalline#ModeLabel())
    endif
endfunction

function! crystalline_settings#parts#Clipboard() abort
    return s:IsClipboardEnabled() ? g:crystalline_symbols.clipboard : ''
endfunction

function! crystalline_settings#parts#Paste() abort
    return &paste ? g:crystalline_symbols.paste : ''
endfunction

function! crystalline_settings#parts#Spell() abort
    return &spell ? toupper(substitute(&spelllang, ',', '/', 'g')) : ''
endfunction

function! crystalline_settings#parts#Indentation(...) abort
    let l:shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    let compact = get(a:, 1, s:IsCompact())
    if compact
        return printf(&expandtab ? 'SPC: %d' : 'TAB: %d', l:shiftwidth)
    else
        return printf(&expandtab ? 'Spaces: %d' : 'Tab Size: %d', l:shiftwidth)
    endif
endfunction

function! s:ReadonlyStatus(...) abort
    return &readonly ? g:crystalline_symbols.readonly . ' ' : ''
endfunction

function! s:ModifiedStatus(...) abort
    if &modified
        return !&modifiable ? '[+-]' : '[+]'
    else
        return !&modifiable ? '[-]' : ''
    endif
endfunction

function! s:ZoomedStatus(...) abort
    return get(g:, 'crystalline_zoomed', 0) ? '[Z]' : ''
endfunction

function! s:SimpleLineInfo(...) abort
    return printf('%3d:%-3d', line('.'), col('.'))
endfunction

function! s:FullLineInfo(...) abort
    if line('w0') == 1 && line('w$') == line('$')
        let l:percent = 'All'
    elseif line('w0') == 1
        let l:percent = 'Top'
    elseif line('w$') == line('$')
        let l:percent = 'Bot'
    else
        let l:percent = printf('%d%%', line('.') * 100 / line('$'))
    endif

    return printf('%4d:%-3d %3s', line('.'), col('.'), l:percent)
endfunction

function! crystalline_settings#parts#LineInfo(...) abort
    return ''
endfunction

function! crystalline_settings#parts#FileEncodingAndFormat() abort
    let l:encoding = strlen(&fileencoding) ? &fileencoding : &encoding
    let l:encoding = (l:encoding ==# 'utf-8') ? '' : l:encoding . ' '
    let l:bomb     = &bomb ? g:crystalline_symbols.bomb . ' ' : ''
    let l:noeol    = &eol ? '' : g:crystalline_symbols.noeol . ' '
    let l:format   = get(g:crystalline_symbols, &fileformat, '[empty]')
    let l:format   = (l:format ==# '[unix]') ? '' : l:format . ' '
    return l:encoding . l:bomb . l:noeol . l:format
endfunction

function! crystalline_settings#parts#FileType(...) abort
    return s:BufferType() . crystalline_settings#devicons#FileType(expand('%'))
endfunction

function! crystalline_settings#parts#FileName(...) abort
    let winwidth = get(a:, 1, 100)
    return s:ReadonlyStatus() . crystalline_settings#FormatFileName(s:FileName(), winwidth, 50) . s:ModifiedStatus() . s:ZoomedStatus()
endfunction

function! crystalline_settings#parts#InactiveFileName(...) abort
    return s:ReadonlyStatus() . s:FileName() . s:ModifiedStatus()
endfunction

function! crystalline_settings#parts#Integration() abort
    let fname = expand('%:t')

    if has_key(g:crystalline_filename_modes, fname)
        let result = { 'name': g:crystalline_filename_modes[fname] }

        if has_key(g:crystalline_filename_integrations, fname)
            return extend(result, function(g:crystalline_filename_integrations[fname])())
        endif

        return result
    endif

    if fname =~# '^NrrwRgn_\zs.*\ze_\d\+$'
        return crystalline_settings#nrrwrgn#Mode()
    endif

    let ft = s:BufferType()

    if ft ==# 'undotree' && exists('*t:undotree.GetStatusLine')
        return crystalline_settings#undotree#Mode()
    endif

    if ft ==# 'diff' && exists('*t:diffpanel.GetStatusLine')
        return crystalline_settings#undotree#DiffStatus()
    endif

    if has_key(g:crystalline_filetype_modes, ft)
        let result = { 'name': g:crystalline_filetype_modes[ft] }

        if has_key(g:crystalline_filetype_integrations, ft)
            return extend(result, function(g:crystalline_filetype_integrations[ft])())
        endif

        return result
    endif

    return {}
endfunction

function! crystalline_settings#parts#GitBranch(...) abort
    return ''
endfunction

function! crystalline_settings#parts#Init() abort
    if g:crystalline_show_git_branch > 0
        function! crystalline_settings#parts#GitBranch(...) abort
            return call('crystalline_settings#git#Branch', a:000)
        endfunction
    endif

    if g:crystalline_show_linenr > 1
        function! crystalline_settings#parts#LineInfo(...) abort
            return call('s:FullLineInfo', a:000)
        endfunction
    elseif g:crystalline_show_linenr > 0
        function! crystalline_settings#parts#LineInfo(...) abort
            return call('s:SimpleLineInfo', a:000)
        endfunction
    endif
endfunction
