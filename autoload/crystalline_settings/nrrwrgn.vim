function! crystalline_settings#nrrwrgn#Mode(...) abort
    let result = { 'name': 'NrrwRgn' }

    if exists(':WidenRegion') == 2
        if exists('b:nrrw_instn')
            let result['name'] = printf('%s#%d', 'NrrwRgn', b:nrrw_instn)
        else
            let l:mode = substitute(bufname('%'), '^Nrrwrgn_\zs.*\ze_\d\+$', submatch(0), '')
            let l:mode = substitute(l:mode, '__', '#', '')
            let result['name'] = l:mode
        endif

        let dict = exists('*nrrwrgn#NrrwRgnStatus()') ?  nrrwrgn#NrrwRgnStatus() : {}

        if len(dict)
            let vmode = { 'v': ' [C]', 'V': '', '': ' [B]' }
            let result['name'] = (dict.multi ? 'Multi' : '') . result['name'] . vmode[dict.visual ? dict.visual : 'V']
            let result['lfill'] = fnamemodify(dict.fullname, ':~:.') . (dict.multi ? '' : printf(' [%d-%d]', dict.start[1], dict.end[1]))
            let result['lfill_inactive'] = result['lfill']
        elseif get(b:, 'orig_buf', 0)
            let result['lfill'] = bufname(b:orig_buf)
            let result['lfill_inactive'] = result['lfill']
        endif
    endif

    return result
endfunction
