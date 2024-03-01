function! crystalline_settings#parts#Mode() abort
    if crystalline_settings#IsCompact()
        return crystalline_settings#Trim(get(g:crystalline_short_mode_labels, mode(), ''))
    else
        return crystalline_settings#Trim(crystalline#ModeLabel())
    endif
endfunction

function! crystalline_settings#parts#Clipboard() abort
    return crystalline_settings#IsClipboardEnabled() ? g:crystalline_symbols.clipboard : ''
endfunction

function! crystalline_settings#parts#Paste() abort
    return &paste ? g:crystalline_symbols.paste : ''
endfunction

function! crystalline_settings#parts#Spell() abort
    return &spell ? toupper(substitute(&spelllang, ',', '/', 'g')) : ''
endfunction

function! crystalline_settings#parts#Indentation(...) abort
    let l:shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    let compact = get(a:, 1, 0)
    if compact
        return printf(&expandtab ? 'SPC: %d' : 'TAB: %d', l:shiftwidth)
    else
        return printf(&expandtab ? 'Spaces: %d' : 'Tab Size: %d', l:shiftwidth)
    endif
endfunction

function! crystalline_settings#parts#Readonly(...) abort
    return &readonly ? g:crystalline_symbols.readonly . ' ' : ''
endfunction

function! crystalline_settings#parts#Modified(...) abort
    if &modified
        if !&modifiable
            return '[+-]'
        else
            return '[+]'
        endif
    elseif !&modifiable
        return '[-]'
    endif

    return ''
endfunction

function! crystalline_settings#parts#SimpleLineInfo(...) abort
    return printf('%3d:%-3d', line('.'), col('.'))
endfunction

function! crystalline_settings#parts#LineInfo(...) abort
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

function! crystalline_settings#parts#FileEncodindAndFormat() abort
    let l:encoding = strlen(&fileencoding) ? &fileencoding : &encoding
    let l:bomb     = &bomb ? '[BOM]' : ''
    let l:format   = strlen(&fileformat) ? printf('[%s]', &fileformat) : ''

    " Skip common string utf-8[unix]
    if (l:encoding . l:format) ==# 'utf-8[unix]'
        return l:bomb
    endif

    return l:encoding . l:bomb . l:format
endfunction

function! crystalline_settings#parts#FileType(...) abort
    return crystalline_settings#BufferType() . crystalline_settings#devicons#FileType(expand('%'))
endfunction

function! crystalline_settings#parts#FileInfo(...) abort
    let parts = [
                \ crystalline_settings#parts#FileEncodindAndFormat(),
                \ crystalline_settings#parts#FileType(),
                \ ]
    return join(filter(copy(parts), 'v:val !=# ""'), ' ')
endfunction

function! crystalline_settings#parts#FileName(...) abort
    let winwidth = get(a:, 1, 100)
    return crystalline_settings#parts#Readonly() . crystalline_settings#FormatFileName(crystalline_settings#FileName(), winwidth, 50) . crystalline_settings#parts#Modified()
endfunction

function! crystalline_settings#parts#InactiveFileName(...) abort
    return crystalline_settings#parts#Readonly() . crystalline_settings#FileName() . crystalline_settings#parts#Modified()
endfunction

let g:crystalline_plugin_modes = {
            \ 'ctrlp':           'crystalline_settings#ctrlp#Mode',
            \ 'netrw':           'crystalline_settings#netrw#Mode',
            \ 'dirvish':         'crystalline_settings#dirvish#Mode',
            \ 'molder':          'crystalline_settings#molder#Mode',
            \ 'vaffle':          'crystalline_settings#vaffle#Mode',
            \ 'fern':            'crystalline_settings#fern#Mode',
            \ 'carbon.explorer': 'crystalline_settings#carbon#Mode',
            \ 'neo-tree':        'crystalline_settings#neotree#Mode',
            \ 'oil':             'crystalline_settings#oil#Mode',
            \ 'tagbar':          'crystalline_settings#tagbar#Mode',
            \ 'vista_kind':      'crystalline_settings#vista#Mode',
            \ 'vista':           'crystalline_settings#vista#Mode',
            \ 'terminal':        'crystalline_settings#terminal#Mode',
            \ 'help':            'crystalline_settings#help#Mode',
            \ 'qf':              'crystalline_settings#quickfix#Mode',
            \ 'gitcommit':       'crystalline_settings#gitcommit#Mode',
            \ }

function! crystalline_settings#parts#Integration() abort
    let fname = expand('%:t')

    if has_key(g:crystalline_filename_modes, fname)
        let result = { 'name': g:crystalline_filename_modes[fname] }

        let l:plugin_modes = {
                    \ 'ControlP':          'crystalline_settings#ctrlp#Mode',
                    \ '__Tagbar__':        'crystalline_settings#tagbar#Mode',
                    \ '__CtrlSF__':        'crystalline_settings#ctrlsf#Mode',
                    \ '__CtrlSFPreview__': 'crystalline_settings#ctrlsf#PreviewMode',
                    \ }
        
        if has_key(l:plugin_modes, fname)
            return extend(result, function(l:plugin_modes[fname])())
        endif
    endif

    if fname =~# '^NrrwRgn_\zs.*\ze_\d\+$'
        return crystalline_settings#nrrwrgn#Mode()
    endif

    let ft = crystalline_settings#BufferType()
    if has_key(g:crystalline_filetype_modes, ft)
        let result = { 'name': g:crystalline_filetype_modes[ft] }

        if has_key(g:crystalline_plugin_modes, ft)
            return extend(result, function(g:crystalline_plugin_modes[ft])())
        endif

        return result
    endif

    return {}
endfunction
