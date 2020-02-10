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
let g:crystalline_show_git_branch = get(g:, 'crystalline_show_git_branch', 1)
let g:crystalline_show_file_size  = get(g:, 'crystalline_show_file_size', 1)
let g:crystalline_show_devicons   = get(g:, 'crystalline_show_devicons', 1)

" Disable NERDTree statusline
let g:NERDTreeStatusline = -1

" Window width
let s:xsmall_window_width = 60
let s:small_window_width  = 80
let s:normal_window_width = 100

" Symbols
let s:symbols = {
            \ 'clipboard': 'ⓒ  ',
            \ 'paste':     'Ⓟ  ',
            \ 'left':      '',
            \ 'right':     '',
            \ 'readonly':  '',
            \ 'ellipsis':  '…',
            \ 'mode_sep':  ' ',
            \ 'fill_sep':  ' ',
            \ }

if !g:crystalline_powerline
    call extend(s:symbols, {
            \ 'left':  '»',
            \ 'right': '«',
            \ })
endif

call extend(s:symbols, {
            \ 'left_sep':  ' ' . s:symbols.left . ' ',
            \ 'right_sep': ' ' . s:symbols.right . ' ',
            \ })

" Alternative Symbols
" ©: Clipboard
"Ⓒ  : Clipboard
"ⓒ  : Clipboard
"ⓒ  : Clipboard
"ⓒ  : Clipboard
"ⓟ  : Paste
"Ⓟ  : Paste
"℗  : Paste
"℗  : Paste
" Ρ: Paste
" ρ: Paste
"Ⓡ  : Readonly
"ⓡ  : Readonly
" ® : Readonly

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
            \ }

let s:filetype_modes = {
            \ 'netrw':             'NetrwTree',
            \ 'nerdtree':          'NERDTree',
            \ 'startify':          'Startify',
            \ 'vim-plug':          'Plugins',
            \ 'terminal':          'Terminal',
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

function! s:ParseList(list) abort
    let l:list = s:EnsureList(a:list)
    return s:RemoveEmptyElement(l:list)
endfunction

function! s:ParseFillList(list, sep) abort
    let l:list = s:EnsureList(a:list)
    let l:list = map(copy(l:list), "type(v:val) == type([]) ? join(s:RemoveEmptyElement(v:val), a:sep) : v:val")
    return s:RemoveEmptyElement(l:list)
endfunction

function! s:ParseMode(mode, sep) abort
    let l:mode = join(s:RemoveEmptyElement(s:EnsureList(a:mode)), a:sep)
    return l:mode
endfunction

function! s:BuildMode(parts, ...) abort
    let sep = get(a:, 1, s:symbols.left_sep)
    return s:ParseMode(a:parts, sep)
endfunction

function! s:BuildRightMode(parts) abort
    return s:BuildMode(a:parts, s:symbols.right_sep)
endfunction

function! s:BuildFill(parts, ...) abort
    let sep = get(a:, 1, s:symbols.left_sep)
    let l:parts = s:ParseFillList(a:parts, sep)
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

    if strlen(fname) > a:winwidth && (fname[0] =~ '\~\|/')
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

    return branch
endfunction

function! s:FormatBranch(branch, winwidth) abort
    if a:winwidth > s:normal_window_width
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

" Copied from https://github.com/ahmedelgabri/dotfiles/blob/master/files/vim/.vim/autoload/statusline.vim
function! s:FileSize() abort
    let l:size = getfsize(expand('%'))
    if l:size == 0 || l:size == -1 || l:size == -2
        return ''
    endif
    if l:size < 1024
        return l:size . ' bytes'
    elseif l:size < 1024 * 1024
        return printf('%.1f', l:size / 1024.0) . 'k'
    elseif l:size < 1024 * 1024 * 1024
        return printf('%.1f', l:size / 1024.0 / 1024.0) . 'm'
    else
        return printf('%.1f', l:size / 1024.0 / 1024.0 / 1024.0) . 'g'
    endif
endfunction

function! s:FileSizeStatus() abort
    if g:crystalline_show_file_size
        return s:FileSize()
    endif
    return ''
endfunction

function! s:IndentationStatus(...) abort
    let shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    let compact = get(a:, 1, 0)
    if compact
        return printf(&expandtab ? 'SPC: %d' : 'TAB: %d', shiftwidth)
    else
        return printf(&expandtab ? 'Spaces: %d' : 'Tab Size: %d', shiftwidth)
    endif
endfunction

function! s:FileEncodingStatus() abort
    let l:encoding = strlen(&fileencoding) ? &fileencoding : &encoding
    " Show encoding only if it is not utf-8
    if empty(l:encoding) || l:encoding ==# 'utf-8'
        return ''
    endif
    return printf('[%s]', l:encoding)
endfunction

function! s:FileEncodingAndFormatStatus() abort
    let l:encoding = strlen(&fileencoding) ? &fileencoding : &encoding

    if strlen(l:encoding) && strlen(&fileformat)
        let stl = printf('%s[%s]', l:encoding, &fileformat)
    elseif strlen(l:encoding)
        let stl = l:encoding
    else
        let stl = printf('[%s]', &fileformat)
    endif

    " Show format only if it is not utf-8[unix]
    if stl ==# 'utf-8[unix]'
        return ''
    endif

    return stl
endfunction

function! s:FileInfoStatus(...) abort
    let ft = s:GetBufferType()

    if g:crystalline_show_devicons && s:has_devicons
        let compact = get(a:, 1, 0)

        let parts = s:RemoveEmptyElement([
                    \ s:FileEncodingStatus(),
                    \ !compact ? WebDevIconsGetFileFormatSymbol() . ' ' : '',
                    \ ft,
                    \ !compact ? WebDevIconsGetFileTypeSymbol(expand('%')) . ' ' : '',
                    \ ])
    else
        let parts = s:RemoveEmptyElement([
                    \ s:FileEncodingAndFormatStatus(),
                    \ ft,
                    \ ])
    endif

    return join(parts, ' ')
endfunction

function! s:GitBranchStatus(...) abort
    if g:crystalline_show_git_branch
        let l:winwidth = get(a:, 1, 100)
        return s:FormatBranch(s:GetGitBranch(), l:winwidth)
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

let s:crystalline_last_custom_mode_time = reltime()

function! s:CustomMode() abort
    if has_key(b:, 'crystalline_custom_mode') && reltimefloat(reltime(s:crystalline_last_custom_mode_time)) < 0.5
        return b:crystalline_custom_mode
    endif
    let b:crystalline_custom_mode = s:FetchCustomMode()
    let s:crystalline_last_custom_mode_time = reltime()
    return b:crystalline_custom_mode
endfunction

function! s:FetchCustomMode() abort
    let fname = expand('%:t')

    if has_key(s:filename_modes, fname)
        let result = {
                    \ 'custom': 1,
                    \ 'name': s:filename_modes[fname],
                    \ 'type': 'name',
                    \ }

        if fname ==# '__CtrlSF__'
            return extend(result, {
                        \ 'lfill': substitute(ctrlsf#utils#SectionB(), 'Pattern: ', '', ''),
                        \ 'lextra': ctrlsf#utils#SectionC(),
                        \ 'rmode': ctrlsf#utils#SectionX(),
                        \ })
        endif

        if fname ==# '__CtrlSFPreview__'
            let result['lfill'] = ctrlsf#utils#PreviewSectionC()
            return result
        endif

        return result
    endif

    if fname =~? '^NrrwRgn'
        let nrrw_rgn_status = s:NrrwRgnStatus()
        if len(nrrw_rgn_status)
            return {
                        \ 'custom': 1,
                        \ 'name': nrrw_rgn_status[0],
                        \ 'lfill': get(nrrw_rgn_status, 1, ''),
                        \ 'type': 'name',
                        \ }
        endif
    endif

    let ft = s:GetBufferType()
    if has_key(s:filetype_modes, ft)
        let result = {
                    \ 'custom': 1,
                    \ 'name': s:filetype_modes[ft],
                    \ 'type': 'filetype',
                    \ }

        if ft ==# 'terminal'
            let result['lfill'] = expand('%')
            return result
        endif

        if ft ==# 'help'
            let result['lfill'] = expand('%:p')
            return result
        endif

        if ft ==# 'qf'
            if getwininfo(win_getid())[0]['loclist']
                let result['name'] = 'Location'
            endif
            let result['lfill'] = s:Strip(get(w:, 'quickfix_title', ''))
            return result
        endif

        return result
    endif

    return { 'custom': 0 }
endfunction

function! s:NrrwRgnStatus(...) abort
    if exists(':WidenRegion') == 2
        let l:modes = []

        if exists('b:nrrw_instn')
            call add(l:modes, printf('%s#%d', 'NrrwRgn', b:nrrw_instn))
        else
            let l:mode = substitute(bufname('%'), '^Nrrwrgn_\zs.*\ze_\d\+$', submatch(0), '')
            let l:mode = substitute(l:mode, '__', '#', '')
            call add(l:modes, l:mode)
        endif

        let dict = exists('*nrrwrgn#NrrwRgnStatus()') ?  nrrwrgn#NrrwRgnStatus() : {}

        if !empty(dict)
            call add(l:modes, fnamemodify(dict.fullname, ':~:.'))
        elseif get(b:, 'orig_buf', 0)
            call add(l:modes, bufname(b:orig_buf))
        endif

        return l:modes
    endif

    return []
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
    if l:mode['custom']
        return s:BuildMode([ l:mode['name'] ])
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    let l:mode = s:Strip(crystalline#mode_label())
    if l:winwidth < s:xsmall_window_width
        let l:mode  = get(s:short_modes, l:mode, l:mode)
    endif

    return s:BuildMode(l:mode)
endfunction

function! StatusLineLeftFill(...) abort
    let l:mode = s:CustomMode()
    if l:mode['custom']
        return s:BuildFill([ get(l:mode, 'lfill', '') ])
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    return s:BuildFill([
                \ s:FileNameStatus(l:winwidth - 2),
                \ ])
endfunction

function! StatusLineLeftExtra(...) abort
    let l:mode = s:CustomMode()
    if l:mode['custom']
        return s:BuildFill(get(l:mode, 'lextra', ''))
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth < s:small_window_width
        return ''
    endif

    return s:BuildFill([
                \ s:GitBranchStatus(l:winwidth),
                \ ])
endfunction

function! StatusLineRightMode(...) abort
    let l:mode = s:CustomMode()
    if l:mode['custom']
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
    if l:mode['custom']
        return s:BuildRightFill(get(l:mode, 'rfill', ''))
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    if l:winwidth < s:small_window_width
        return ''
    endif

    let compact = s:IsCompact(l:winwidth)

    return s:BuildRightFill([
                \ s:IndentationStatus(compact),
                \ s:FileSizeStatus(),
                \ ])
endfunction

function! StatusLineRightExtra(...) abort
    let l:mode = s:CustomMode()
    if l:mode['custom']
        return s:BuildRightFill(get(l:mode, 'rextra', ''))
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))
    if l:winwidth < s:small_window_width
        return ''
    endif

    return s:BuildRightFill([
                \ s:ClipboardStatus(),
                \ s:PasteStatus(),
                \ s:SpellStatus(),
                \ ])
endfunction

function! StatusLineInactiveMode(...) abort
    " show only custom mode in inactive buffer
    let l:mode = s:CustomMode()
    if l:mode['custom']
        return s:BuildMode([ l:mode['name'], get(l:mode, 'lfill', '') ])
    endif

    let l:winwidth = winwidth(get(a:, 1, 0))

    " plugin/statusline.vim[+]
    return s:FileNameStatus(l:winwidth - 2)
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

" Plugin Status
function! s:Surround(str) abort
    return strlen(a:str) ? ' ' . a:str . ' ' : a:str
endfunction

function! s:BuildLeftStatus(parts) abort
    let l:parts = s:ParseList(a:parts)

    let l:mode = s:Surround(s:ParseMode(get(l:parts, 0, []), s:symbols.left_sep))

    let stl = crystalline#mode_color() . l:mode . crystalline#right_mode_sep('')

    let l:fill = s:Surround(s:BuildFill(l:parts[1:1], s:symbols.left_sep))
    let stl .= l:fill . crystalline#right_sep('', 'Fill')

    let l:extra = s:Surround(s:BuildFill(l:parts[2:], s:symbols.left_sep))
    let stl .= l:extra

    return stl
endfunction

function! s:BuildRightStatus(parts) abort
    let l:parts = s:ParseList(a:parts)

    let result = []

    let l:mode = s:Surround(s:ParseMode(get(l:parts, 0, ''), s:symbols.right_sep))
    call insert(result, crystalline#left_mode_sep('') . l:mode, 0)

    let l:fill = s:Surround(s:BuildRightFill(l:parts[1:1]))
    call insert(result, crystalline#left_sep('', 'Fill') . l:fill, 0)

    let l:extra = s:Surround(s:BuildRightFill(l:parts[2:]))
    call insert(result, l:extra, 0)

    return join(result, '')
endfunction

function! s:BuildPluginStatus(left_parts, ...) abort
    let left_parts  = s:ParseList(a:left_parts)
    let right_parts = s:ParseList(get(a:, 1, []))

    let stl = '%<' . s:BuildLeftStatus(left_parts)

    let stl .= '%='

    if len(right_parts) > 0
        let stl .= '%<' . s:BuildRightStatus(right_parts)
    endif

    return stl
endfunction


" CtrlP Integration
let g:ctrlp_status_func = {
            \ 'main': 'CtrlPMainStatusLine',
            \ 'prog': 'CtrlPProgressStatusLine',
            \ }

function! CtrlPMainStatusLine(focus, byfname, regex, prev, item, next, marked) abort
    return s:BuildPluginStatus(
                \ [
                \   s:filename_modes['ControlP'],
                \   [ a:prev, printf(' « %s » ', a:item), a:next],
                \ ],
                \ [
                \   s:GetCurrentDir(),
                \   a:byfname,
                \   a:focus,
                \ ])
endfunction

function! CtrlPProgressStatusLine(len) abort
    return s:BuildPluginStatus([ a:len ], [ s:GetCurrentDir() ])
endfunction

" Tagbar Integration
let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
    if empty(a:flags)
        return s:BuildPluginStatus([a:sort, a:fname])
    else
        return s:BuildPluginStatus([a:sort, a:fname, printf('[%s]', join(a:flags, ''))])
    endif
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
