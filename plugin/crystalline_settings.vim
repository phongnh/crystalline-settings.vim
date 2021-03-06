" crystalline_settings.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    finish
endif

let g:loaded_vim_crystalline_settings = 1

let s:save_cpo = &cpo
set cpo&vim

" Crystalline Settings
let g:crystalline_enable_sep      = get(g:, 'crystalline_powerline', 0)
let g:crystalline_theme           = get(g:, 'crystalline_theme', 'solarized')
let g:crystalline_shorten_path    = get(g:, 'crystalline_shorten_path', 0)
let g:crystalline_show_git_branch = get(g:, 'crystalline_show_git_branch', 1)
let g:crystalline_show_devicons   = get(g:, 'crystalline_show_devicons', 1)

" Disable NERDTree statusline
let g:NERDTreeStatusline = -1

" Window width
let s:xsmall_window_width = 60
let s:small_window_width  = 80
let s:normal_window_width = 120

" Symbols: https://en.wikipedia.org/wiki/Enclosed_Alphanumerics
let s:symbols = {
            \ 'left':      "\ue0b1",
            \ 'right':     "\ue0b3",
            \ 'branch':    "\ue0a0",
            \ 'readonly':  "\ue0a2",
            \ 'clipboard': 'ⓒ  ',
            \ 'paste':     'Ⓟ  ',
            \ 'ellipsis':  '…',
            \ 'mode_sep':  ' ',
            \ 'fill_sep':  ' ',
            \ }

if !g:crystalline_enable_sep
    call extend(s:symbols, {
            \ 'left':     '»',
            \ 'right':    '«',
            \ 'branch':   '',
            \ 'readonly': '',
            \ })
endif

call extend(s:symbols, {
            \ 'left_sep':  ' ' . s:symbols.left . ' ',
            \ 'right_sep': ' ' . s:symbols.right . ' ',
            \ })

" Short modes
let s:short_modes = {
            \ 'NORMAL':   'N',
            \ 'INSERT':   'I',
            \ 'VISUAL':   'V',
            \ 'V-LINE':   'L',
            \ 'V-BLOCK':  'B',
            \ 'COMMAND':  'C',
            \ 'SELECT':   'S',
            \ 'S-LINE':   'S-L',
            \ 'S-BLOCK':  'S-B',
            \ 'TERMINAL': 'T',
            \ }

" Detect DevIcons
let s:has_devicons = findfile('plugin/webdevicons.vim', &rtp) != ''
" let s:has_devicons = exists('*WebDevIconsGetFileTypeSymbol') && exists('*WebDevIconsGetFileFormatSymbol')

" Alternate status dictionaries
let s:filename_modes = {
            \ 'ControlP':             'CtrlP',
            \ '__CtrlSF__':           'CtrlSF',
            \ '__CtrlSFPreview__':    'Preview',
            \ '__Tagbar__':           'Tagbar',
            \ '__Gundo__':            'Gundo',
            \ '__Gundo_Preview__':    'Gundo Preview',
            \ '[BufExplorer]':        'BufExplorer',
            \ '[Command Line]':       'Command Line',
            \ '[Plugins]':            'Plugins',
            \ '__committia_status__': 'Committia Status',
            \ '__committia_diff__':   'Committia Diff',
            \ '__doc__':              'Document',
            \ }

let s:filetype_modes = {
            \ 'netrw':             'NetrwTree',
            \ 'nerdtree':          'NERDTree',
            \ 'fern':              'Fern',
            \ 'startify':          'Startify',
            \ 'tagbar':            'Tagbar',
            \ 'vim-plug':          'Plugins',
            \ 'terminal':          'TERMINAL',
            \ 'help':              'HELP',
            \ 'qf':                'Quickfix',
            \ 'godoc':             'GoDoc',
            \ 'gedoc':             'GeDoc',
            \ 'gitcommit':         'Commit Message',
            \ 'fugitiveblame':     'FugitiveBlame',
            \ 'gitmessengerpopup': 'Git Messenger',
            \ 'agit':              'Agit',
            \ 'agit_diff':         'Agit Diff',
            \ 'agit_stat':         'Agit Stat',
            \ }

function! s:Hi(group) abort
    return printf('%%#%s#', a:group)
endfunction

function! s:Strip(str) abort
    if exists('*trim')
        return trim(a:str)
    else
        return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
    endif
endfunction

function! s:Wrap(text) abort
    return printf('%s %s %s', '«', a:text, '»')
endfunction

function! s:ShortenPath(filename) abort
    if exists('*pathshorten')
        return pathshorten(a:filename)
    else
        return substitute(a:filename, '\v\w\zs.{-}\ze(\\|/)', '', 'g')
    endif
endfunction

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

function! s:GetBufferType() abort
    return strlen(&filetype) ? &filetype : &buftype
endfunction

function! s:GetFileName() abort
    let fname = expand('%:~:.')

    if empty(fname)
        return '[No Name]'
    endif

    return fname
endfunction

function! s:FormatFileName(fname, winwidth, max_width) abort
    let fname = a:fname

    if a:winwidth < s:small_window_width
        return fnamemodify(fname, ':t')
    endif

    if strlen(fname) > a:winwidth && (fname[0] =~ '\~\|/') && g:crystalline_shorten_path
        let fname = s:ShortenPath(fname)
    endif

    let max_width = min([a:winwidth, a:max_width])

    if strlen(fname) > max_width
        let fname = fnamemodify(fname, ':t')
    endif

    return fname
endfunction

function! s:GetFileFlags() abort
    let flags = ''

    " file modified and modifiable
    if &modified
        if !&modifiable
            let flags .= '[+-]'
        else
            let flags .= '[+]'
        endif
    elseif !&modifiable
        let flags .= '[-]'
    endif

    if &readonly
        let flags .= ' ' . s:symbols.readonly . ' '
    endif

    return flags
endfunction

function! s:GetGitBranch() abort
    " Get branch from caching if it is available
    if has_key(b:, 'crystalline_git_branch') && reltimefloat(reltime(s:crystalline_last_finding_branch_time)) < s:crystalline_time_threshold
        return b:crystalline_git_branch
    endif

    let branch = ''

    if exists('*FugitiveHead')
        let branch = FugitiveHead()

        if empty(branch) && exists('*FugitiveDetect') && !exists('b:git_dir')
            call FugitiveDetect(getcwd())
            let branch = FugitiveHead()
        endif
    elseif exists('*fugitive#head')
        let branch = fugitive#head()

        if empty(branch) && exists('*fugitive#detect') && !exists('b:git_dir')
            call fugitive#detect(getcwd())
            let branch = fugitive#head()
        endif
    elseif exists(':Gina') == 2
        let branch = gina#component#repo#branch()
    endif

    " Caching
    let b:crystalline_git_branch = branch
    let s:crystalline_last_finding_branch_time = reltime()

    return branch
endfunction

function! s:ShortenBranch(branch, length) abort
    let branch = a:branch

    if strlen(branch) > a:length
        let branch = s:ShortenPath(branch)
    endif

    if strlen(branch) > a:length
        let branch = fnamemodify(branch, ':t')
    endif

    if strlen(branch) > a:length
        " Show only JIRA ticket prefix
        let branch = substitute(branch, '^\([A-Z]\{3,}-\d\{1,}\)-.\+', '\1', '')
    endif

    return branch
endfunction

function! s:FormatBranch(branch, winwidth) abort
    if a:winwidth >= s:normal_window_width
        return s:ShortenBranch(a:branch, 50)
    endif

    let branch = s:ShortenBranch(a:branch, 30)

    if strlen(branch) > 30
        let branch = strcharpart(branch, 0, 29) . s:symbols.ellipsis
    endif

    return branch
endfunction

function! s:FileNameStatus(...) abort
    let winwidth = get(a:, 1, 100)
    return s:FormatFileName(s:GetFileName(), winwidth, 50) . s:GetFileFlags()
endfunction

function! s:InactiveFileNameStatus(...) abort
    return s:GetFileName() . s:GetFileFlags()
endfunction

function! s:IndentationStatus(...) abort
    let l:shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    let compact = get(a:, 1, 0)
    if compact
        return printf(&expandtab ? 'SPC: %d' : 'TAB: %d', l:shiftwidth)
    else
        return printf(&expandtab ? 'Spaces: %d' : 'Tab Size: %d', l:shiftwidth)
    endif
endfunction

function! s:FileEncodingAndFormatStatus() abort
    let l:encoding = strlen(&fileencoding) ? &fileencoding : &encoding
    let l:bomb     = &bomb ? '[BOM]' : ''
    let l:format   = strlen(&fileformat) ? printf('[%s]', &fileformat) : ''

    " Skip common string utf-8[unix]
    if (l:encoding . l:format) ==# 'utf-8[unix]'
        return l:bomb
    endif

    return l:encoding . l:bomb . l:format
endfunction

function! s:FileInfoStatus(...) abort
    let parts = [
                \ s:FileEncodingAndFormatStatus(),
                \ s:GetBufferType(),
                \ ]

    let compact = get(a:, 1, 0)

    if g:crystalline_show_devicons && s:has_devicons && !compact
        call extend(parts, [
                    \ WebDevIconsGetFileTypeSymbol(expand('%')) . ' ',
                    \ WebDevIconsGetFileFormatSymbol() . ' ',
                    \ ])
    endif

    return join(s:RemoveEmptyElement(parts), ' ')
endfunction

function! s:GitBranchStatus(...) abort
    if g:crystalline_show_git_branch
        let l:winwidth = get(a:, 1, 100)
        let branch = s:FormatBranch(s:GetGitBranch(), l:winwidth)

        if strlen(branch)
            return s:Strip(s:symbols.branch . ' ' . branch)
        endif
    endif

    return ''
endfunction

function! s:ClipboardStatus() abort
    if match(&clipboard, 'unnamed') > -1
        return s:symbols.clipboard
    endif
    return ''
endfunction

function! s:PasteStatus() abort
    if &paste
        return s:symbols.paste
    endif
    return ''
endfunction

function! s:SpellStatus() abort
    if &spell
        return toupper(substitute(&spelllang, ',', '/', 'g'))
    endif
    return ''
endfunction

function! s:IsCompact(winwidth) abort
    return &spell || &paste || strlen(s:ClipboardStatus()) || a:winwidth <= s:xsmall_window_width
endfunction

function! s:BuildGroup(exp) abort
    if a:exp =~ '^%'
        return '%( ' . a:exp . ' %)'
    else
        return '%( %{' . a:exp . '} %)'
    endif
endfunction

function! StatusLineActiveMode(...) abort
    " custom status
    let l:mode = s:CustomMode()
    if len(l:mode)
        return s:BuildMode([ l:mode['name'] ])
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    let l:mode = s:Strip(crystalline#mode_label())
    if l:winwidth <= s:xsmall_window_width
        let l:mode  = get(s:short_modes, l:mode, l:mode)
    endif

    return s:BuildMode(l:mode)
endfunction

function! StatusLineLeftFill(...) abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return s:BuildFill([ get(l:mode, 'lfill', '') ])
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth >= s:small_window_width
        return s:BuildFill([
                    \ s:GitBranchStatus(l:winwidth),
                    \ s:FileNameStatus(l:winwidth - 2),
                    \ ])
    endif

    return s:BuildFill([
                \ s:FileNameStatus(l:winwidth - 2),
                \ ])
endfunction

function! StatusLineLeftExtra(...) abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return s:BuildFill(get(l:mode, 'lextra', ''))
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth >= s:small_window_width
    endif

    return ''
endfunction

function! StatusLineRightMode(...) abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return s:BuildRightMode(get(l:mode, 'rmode', ''))
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))
    let compact = s:IsCompact(l:winwidth)

    return s:BuildRightMode([
                \ s:FileInfoStatus(compact),
                \ ])
endfunction

function! StatusLineRightFill(...) abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return s:BuildRightFill(get(l:mode, 'rfill', ''))
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth >= s:small_window_width
        let compact = s:IsCompact(l:winwidth)
        return s:BuildRightFill([
                    \ s:IndentationStatus(compact),
                    \ ])
    endif

    return ''
endfunction

function! StatusLineRightExtra(...) abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return s:BuildRightFill(get(l:mode, 'rextra', ''))
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth >= s:small_window_width
        return s:BuildRightFill([
                    \ s:ClipboardStatus(),
                    \ s:PasteStatus(),
                    \ s:SpellStatus(),
                    \ ])
    endif

    return ''
endfunction

function! StatusLineInactiveMode(...) abort
    " show only custom mode in inactive buffer
    let l:mode = s:CustomMode()
    if len(l:mode)
        return s:BuildMode([ l:mode['name'], get(l:mode, 'lfill_inactive', '') ])
    endif

    " plugin/statusline.vim[+]
    return s:InactiveFileNameStatus()
endfunction

function! StatusLine(current, win) abort
    let winnum = win_id2win(a:win)
    if a:current
        return join([
                    \ crystalline#mode_color(),
                    \ '%<',
                    \ s:BuildGroup(printf('StatusLineActiveMode(%d)', winnum)),
                    \ crystalline#right_mode_sep(''),
                    \ s:BuildGroup(printf('StatusLineLeftFill(%d)', winnum)),
                    \ crystalline#right_sep('', 'Fill'),
                    \ s:BuildGroup(printf('StatusLineLeftExtra(%d)', winnum)),
                    \ '%=',
                    \ '%<',
                    \ s:BuildGroup(printf('StatusLineRightExtra(%d)', winnum)),
                    \ crystalline#left_sep('', 'Fill'),
                    \ s:BuildGroup(printf('StatusLineRightFill(%d)', winnum)),
                    \ crystalline#left_mode_sep(''),
                    \ s:BuildGroup(printf('StatusLineRightMode(%d)', winnum)),
                    \ ], '')
    else
        return s:Hi('CrystallineInactive') .
                    \ '%<' .
                    \ s:BuildGroup(printf('StatusLineInactiveMode(%d)', winnum))
    endif
endfunction

function! TabLine() abort
    let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
    return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=' . s:Hi('CrystallineTab') . l:vimlabel
endfunction

let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn    = 'TabLine'

function s:Init() abort
    " FIXME: Overwriting crystalline#get_statusline function
    function! crystalline#get_statusline(current, win) abort
        call crystalline#trigger_mode_update()
        try
            return function(g:crystalline_statusline_fn)(a:current, a:win)
        catch /^Vim\%((\a\+)\)\=:E118/
            return function(g:crystalline_statusline_fn)(a:current)
        endtry
    endfunction
endfunction

augroup VimCrystallineSettings
    autocmd!
    autocmd VimEnter * call s:Init()
augroup END

" Plugin Integration
" Save plugin states
let s:crystalline = {}
let s:crystalline_time_threshold = 0.50
let s:crystalline_last_finding_branch_time = reltime()

function! s:CustomMode() abort
    let fname = expand('%:t')

    if has_key(s:filename_modes, fname)
        let result = {
                    \ 'name': s:filename_modes[fname],
                    \ 'type': 'name',
                    \ }

        if fname ==# 'ControlP'
            return extend(result, s:GetCtrlPMode())
        endif

        if fname ==# '__Tagbar__'
            return extend(result, s:GetTagbarMode())
        endif

        if fname ==# '__CtrlSF__'
            return extend(result, s:GetCtrlSFMode())
        endif

        if fname ==# '__CtrlSFPreview__'
            return extend(result, s:GetCtrlSFPreviewMode())
        endif

        return result
    endif

    if fname =~? '^NrrwRgn'
        let nrrw_rgn_mode = s:GetNrrwRgnMode()
        if len(nrrw_rgn_mode)
            return nrrw_rgn_mode
        endif
    endif

    let ft = s:GetBufferType()
    if has_key(s:filetype_modes, ft)
        let result = {
                    \ 'name': s:filetype_modes[ft],
                    \ 'type': 'filetype',
                    \ }

        if ft ==# 'fern'
            return extend(result, s:GetFernMode(expand('%')))
        endif

        if ft ==# 'tagbar'
            return extend(result, s:GetTagbarMode())
        endif

        if ft ==# 'terminal'
            return extend(result, {
                        \ 'lfill': expand('%'),
                        \ })
        endif

        if ft ==# 'help'
            let fname = expand('%:p')
            return extend(result, {
                        \ 'lfill': fname,
                        \ 'lfill_inactive': fname,
                        \ })
        endif

        if ft ==# 'qf'
            if getwininfo(win_getid())[0]['loclist']
                let result['name'] = 'Location'
            endif
            let qf_title = s:Strip(get(w:, 'quickfix_title', ''))
            return extend(result, {
                        \ 'lfill': qf_title,
                        \ 'lfill_inactive': qf_title,
                        \ })
        endif

        return result
    endif

    return {}
endfunction

" CtrlP Integration
let g:ctrlp_status_func = {
            \ 'main': 'CtrlPMainStatusLine',
            \ 'prog': 'CtrlPProgressStatusLine',
            \ }

function! s:GetCtrlPMode() abort
    let result = {
                \ 'name': s:filename_modes['ControlP'],
                \ 'rmode': s:crystalline.ctrlp_dir,
                \ 'type': 'ctrlp',
                \ }

    if s:crystalline.ctrlp_main
        let lfill = s:BuildFill([
                    \ s:crystalline.ctrlp_prev,
                    \ ' ' . s:Wrap(s:crystalline.ctrlp_item) . ' ',
                    \ s:crystalline.ctrlp_next,
                    \ ])

        let rfill = s:BuildRightFill([
                    \ s:crystalline.ctrlp_focus,
                    \ s:crystalline.ctrlp_byfname,
                    \ ])

        call extend(result, {
                \ 'lfill': lfill,
                \ 'rfill': rfill,
                \ })
    else
        call extend(result, {
                    \ 'lfill': s:crystalline.ctrlp_len,
                    \ })
    endif

    return result
endfunction

function! CtrlPMainStatusLine(focus, byfname, regex, prev, item, next, marked) abort
    let s:crystalline.ctrlp_main    = 1
    let s:crystalline.ctrlp_focus   = a:focus
    let s:crystalline.ctrlp_byfname = a:byfname
    let s:crystalline.ctrlp_regex   = a:regex
    let s:crystalline.ctrlp_prev    = a:prev
    let s:crystalline.ctrlp_item    = a:item
    let s:crystalline.ctrlp_next    = a:next
    let s:crystalline.ctrlp_marked  = a:marked
    let s:crystalline.ctrlp_dir     = s:GetCurrentDir()

    return StatusLine(1, winnr())
endfunction

function! CtrlPProgressStatusLine(len) abort
    let s:crystalline.ctrlp_main = 0
    let s:crystalline.ctrlp_len  = a:len
    let s:crystalline.ctrlp_dir  = s:GetCurrentDir()

    return StatusLine(1, winnr())
endfunction

" Fern Integration
function! s:GetFernMode(...) abort
    let result = {}

    let fern_name = get(a:, 1, expand('%'))
    let pattern = '^fern://\(.\+\)/file://\(.\+\)\$'
    let data = matchlist(fern_name, pattern)

    if len(data)
        let fern_mode = get(data, 1, '')
        if match(fern_mode, 'drawer') > -1
            let result['name'] = 'Drawer#' . matchstr(fern_mode, '\d\+')
        endif

        let fern_folder = get(data, 2, '')
        let fern_folder = substitute(fern_folder, ';\?#.\+', '', '')
        let fern_folder = fnamemodify(fern_folder, ':p:~:.:h')

        let result['lfill'] = fern_folder
    endif

    return result
endfunction

" CtrlSF Integration
function! s:GetCtrlSFMode() abort
    let pattern = substitute(ctrlsf#utils#SectionB(), 'Pattern: ', '', '')

    return {
                \ 'lfill': pattern,
                \ 'lfill_inactive': pattern,
                \ 'lextra': ctrlsf#utils#SectionC(),
                \ 'rmode': ctrlsf#utils#SectionX(),
                \ }
endfunction

function! s:GetCtrlSFPreviewMode() abort
    let stl = ctrlsf#utils#PreviewSectionC()
    return {
                \ 'lfill': stl,
                \ 'lfill_inactive': stl,
                \ }
endfunction

" NrrwRgn Integration
function! s:GetNrrwRgnMode(...) abort
    let result = {}

    if exists(':WidenRegion') == 2
        let result['type'] = 'nrrwrgn'

        if exists('b:nrrw_instn')
            let result['name'] = printf('%s#%d', 'NrrwRgn', b:nrrw_instn)
        else
            let l:mode = substitute(bufname('%'), '^Nrrwrgn_\zs.*\ze_\d\+$', submatch(0), '')
            let l:mode = substitute(l:mode, '__', '#', '')
            let result['name'] = l:mode
        endif

        let dict = exists('*nrrwrgn#NrrwRgnStatus()') ?  nrrwrgn#NrrwRgnStatus() : {}

        if len(dict)
            let result['lfill'] = fnamemodify(dict.fullname, ':~:.')
            let result['lfill_inactive'] = result['lfill']
        elseif get(b:, 'orig_buf', 0)
            let result['lfill'] = bufname(b:orig_buf)
            let result['lfill_inactive'] = result['lfill']
        endif
    endif

    return result
endfunction

" Tagbar Integration
let g:tagbar_status_func = 'TagbarStatusFunc'

function! s:GetTagbarMode() abort
    if empty(s:crystalline.tagbar_flags)
        let lextra = ''
    else
        let lextra = printf('[%s]', join(s:crystalline.tagbar_flags, ''))
    endif

    return {
                \ 'name': s:crystalline.tagbar_sort,
                \ 'lfill': s:crystalline.tagbar_fname,
                \ 'lextra': lextra,
                \ 'type': 'tagbar',
                \ }
endfunction

function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
    let s:crystalline.tagbar_sort  = a:sort
    let s:crystalline.tagbar_fname = a:fname
    let s:crystalline.tagbar_flags = a:flags

    return StatusLine(1, winnr())
endfunction

" ZoomWin Integration
let s:ZoomWin_funcref = []

if exists('g:ZoomWin_funcref')
    if type(g:ZoomWin_funcref) == 2
        let s:ZoomWin_funcref = [g:ZoomWin_funcref]
    elseif type(g:ZoomWin_funcref) == 3
        let s:ZoomWin_funcref = g:ZoomWin_funcref
    endif
endif
let s:ZoomWin_funcref = uniq(copy(s:ZoomWin_funcref))

function! ZoomWinStatusLine(zoomstate) abort
    for F in s:ZoomWin_funcref
        if type(F) == 2 && F != function('ZoomWinStatusLine')
            call F(a:zoomstate)
        endif
    endfor
endfunction

let g:ZoomWin_funcref= function('ZoomWinStatusLine')

let &cpo = s:save_cpo
unlet s:save_cpo
