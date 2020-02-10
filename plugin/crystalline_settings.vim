if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    finish
endif

let g:loaded_vim_crystalline_settings = 1

let s:save_cpo = &cpo
set cpo&vim

" Crystalline Settings
let g:crystalline_enable_sep     = get(g:, 'crystalline_powerline', 0)
let g:crystalline_theme          = get(g:, 'crystalline_theme', 'solarized')
let g:crystalline_show_file_size = get(g:, 'crystalline_show_file_size', 1)
let g:crystalline_show_devicons  = get(g:, 'crystalline_show_devicons', 1)

" Window width
let s:xsmall_window_width = 60
let s:small_window_width  = 80
let s:normal_window_width = 100

" Symbols
let s:symbols = {
            \ 'clipboard': 'ⓒ ',
            \ 'paste':     'Ⓟ ',
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

" Support DevIcons
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
            \ 'qf':                '%q',
            \ 'godoc':             'GoDoc',
            \ 'gedoc':             'GeDoc',
            \ 'gitcommit':         'Commit Message',
            \ 'fugitiveblame':     'FugitiveBlame',
            \ 'gitmessengerpopup': 'Git Messenger',
            \ 'agit':              'Agit',
            \ 'agit_diff':         'Agit Diff',
            \ 'agit_stat':         'Agit Stat',
            \ }

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

function! s:Hi(group) abort
    return printf('%%#%s#', a:group)
endfunction

function! s:GetCurrentDir() abort
    let dir = fnamemodify(getcwd(), ':~:.')
    if empty(dir)
        let dir = getcwd()
    endif
    return dir
endfunction

function! s:GetBufferType(bufnum) abort
    let ft = getbufvar(a:bufnum, '&filetype')

    if empty(ft)
        let ft = getbufvar(a:bufnum, '&buftype')
    endif

    return ft
endfunction

function! s:GetFileName(bufnum) abort
    let fname = bufname(a:bufnum)

    if empty(fname)
        return '[No Name]'
    endif

    return fnamemodify(fname, ':~:.')
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
        let fname = s:ShortenPath(fname)
    endif

    if strlen(fname) > max_width
        let fname = fnamemodify(fname, ':t')
    endif

    return fname
endfunction

function! s:GetFileFlags(bufnum) abort
    let flags = ''

    " file modified and modifiable
    if getbufvar(a:bufnum, '&modified')
        if !getbufvar(a:bufnum, '&modifiable')
            let flags .= '[+-]'
        else
            let flags .= '[+]'
        endif
    elseif !getbufvar(a:bufnum, '&modifiable')
        let flags .= '[-]'
    endif

    if getbufvar(a:bufnum, '&readonly')
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

function! s:FileNameStatus(bufnum, ...) abort
    " return %f%h%w%m%r
    let winwidth = get(a:, 1, 100)
    return s:FormatFileName(s:GetFileName(a:bufnum), winwidth, 50) . s:GetFileFlags(a:bufnum)
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

function! s:FileSizeStatus(...) abort
    if g:crystalline_show_file_size
        return s:FileSize()
    endif
    return ''
endfunction

function! s:IndentationStatus(...) abort
    let shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    return printf('%s: %d', (&expandtab ? 'Spaces' : 'Tab Size'), shiftwidth)
endfunction

function! s:FileEncodingStatus(bufnum) abort
    let encoding = getbufvar(a:bufnum, '&fileencoding')
    if empty(encoding)
        let encoding = getbufvar(a:bufnum, '&encoding')
    endif
    " Show encoding only if it is not utf-8
    if empty(encoding) || encoding ==# 'utf-8'
        return ''
    endif
    return printf('[%s]', encoding)
endfunction

function! s:FileEncodingAndFormatStatus(bufnum) abort
    let encoding = getbufvar(a:bufnum, '&fileencoding')
    if empty(encoding)
        let encoding = getbufvar(a:bufnum, '&encoding')
    endif

    let format = getbufvar(a:bufnum, '&fileformat')

    if strlen(encoding) && strlen(format)
        let stl = printf('%s[%s]', encoding, format)
    elseif strlen(encoding)
        let stl = encoding
    else
        let stl = printf('[%s]', format)
    endif

    " Show format only if it is not utf-8[unix]
    if stl ==# 'utf-8[unix]'
        return ''
    endif

    return stl
endfunction

function! s:FileInfoStatus(bufnum) abort
    let ft = s:GetBufferType(a:bufnum)

    if g:crystalline_show_devicons && s:has_devicons
        let parts = s:RemoveEmptyElement([
                    \ s:FileEncodingStatus(a:bufnum),
                    \ WebDevIconsGetFileFormatSymbol() . ' ',
                    \ ft,
                    \ WebDevIconsGetFileTypeSymbol(bufname(a:bufnum)) . ' ',
                    \ ])
    else
        let parts = s:RemoveEmptyElement([
                    \ s:FileEncodingAndFormatStatus(a:bufnum),
                    \ ft,
                    \ ])
    endif

    return join(parts, ' ') . ' '
endfunction

function! s:GitBranchStatus(...) abort
    let l:winwidth = get(a:, 1, 100)

    if g:crystalline_show_git_branch && l:winwidth >= s:small_window_width
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

function! s:StatusSeparator() abort
    return '%='
endfunction

function! s:ParseMode(mode, sep) abort
    let l:mode = join(s:RemoveEmptyElement(s:EnsureList(a:mode)), a:sep)
    let l:mode = strlen(l:mode) ? printf(' %s ', l:mode) : ' '
    return l:mode
endfunction

function! s:BuildMode(...) abort
    let l:mode = s:ParseMode(a:000, s:symbols.left_sep)
    return crystalline#mode_color() . l:mode . crystalline#right_mode_sep('')
endfunction

function! s:BuildLeftStatus(parts) abort
    let l:parts = s:ParseList(a:parts)

    let stl = s:BuildMode(get(l:parts, 0, []))

    let l:fill_parts = s:ParseFillList(l:parts[1:1], s:symbols.left_sep)
    if len(l:fill_parts) > 0
        let l:fill = ' ' . join(l:fill_parts, s:symbols.left_sep) . ' '
    else
        let l:fill = ''
    endif
    let stl .= l:fill . crystalline#right_sep('', 'Fill')

    let l:extra_parts = s:ParseFillList(l:parts[2:], s:symbols.left_sep)
    if len(l:extra_parts) > 0
        let l:extra = ' ' . join(l:extra_parts, s:symbols.left_sep) . ' '
    else
        let l:extra = ''
    endif
    let stl .= l:extra

    return stl
endfunction

function! s:BuildRightStatus(parts) abort
    let l:parts = s:ParseList(a:parts)

    let result = []

    let l:mode = s:ParseMode(get(l:parts, 0, ''), s:symbols.right_sep)
    call insert(result, crystalline#left_mode_sep('') . l:mode, 0)

    let l:fill_parts = s:ParseFillList(l:parts[1:1], s:symbols.right_sep)
    if len(l:fill_parts) > 0
        let l:fill = ' ' . join(l:fill_parts, s:symbols.right_sep) . ' '
    else
        let l:fill = ''
    endif
    call insert(result, crystalline#left_sep('', 'Fill') . l:fill, 0)

    let l:extra_parts = s:ParseFillList(l:parts[2:], s:symbols.right_sep)
    if len(l:extra_parts) > 0
        let l:extra = ' ' . join(l:extra_parts, s:symbols.right_sep) . ' '
    else
        let l:extra = ''
    endif
    call insert(result, l:extra, 0)

    return join(result, '')
endfunction

function! s:BuildStatus(left_parts, ...) abort
    let left_parts  = s:ParseList(a:left_parts)
    let right_parts = s:ParseList(get(a:, 1, []))

    let stl = '%<' . s:BuildLeftStatus(left_parts)

    let stl .= s:StatusSeparator()

    if len(right_parts) > 0
        let stl .= '%<' . s:BuildRightStatus(right_parts)
    endif

    return stl
endfunction

function! s:CustomMode(bufnum) abort
    let ft = s:GetBufferType(a:bufnum)

    if has_key(s:filetype_modes, ft)
        return s:filetype_modes[ft]
    endif

    let fname = fnamemodify(bufname(a:bufnum), ':t')
    if has_key(s:filename_modes, fname)
        return s:filename_modes[fname]
    endif

    if fname =~? '^NrrwRgn' && exists('b:nrrw_instn')
        return printf('%s#%d', 'NrrwRgn', b:nrrw_instn)
    endif

    return ''
endfunction

function! s:CustomStatus(bufnum) abort
    let l:mode = ''

    let ft = s:GetBufferType(a:bufnum)
    if has_key(s:filetype_modes, ft)
        let l:mode = s:filetype_modes[ft]

        if ft ==# 'terminal'
            return s:BuildStatus([ l:mode, '%f' ])
        endif

        if ft ==# 'help'
            return s:BuildStatus([ l:mode, fnamemodify(bufname(a:bufnum), ':p') ])
        endif

        if ft ==# 'qf'
            let l:qf_title = s:Strip(get(w:, 'quickfix_title', ''))
            return s:BuildStatus([ l:mode, l:qf_title ])
        endif
    endif

    let fname = fnamemodify(bufname(a:bufnum), ':t')
    if has_key(s:filename_modes, fname)
        let l:mode = s:filename_modes[fname]

        if fname ==# '__CtrlSF__'
            return s:BuildStatus(
                        \ [
                        \   l:mode,
                        \   substitute(ctrlsf#utils#SectionB(), 'Pattern: ', '', ''),
                        \   ctrlsf#utils#SectionC(),
                        \ ],
                        \ [
                        \   ctrlsf#utils#SectionX()
                        \ ]
                        \ )
        endif

        if fname ==# '__CtrlSFPreview__'
            return s:BuildStatus([ l:mode, ctrlsf#utils#PreviewSectionC() ])
        endif
    endif

    if fname =~? '^NrrwRgn' && exists('b:nrrw_instn')
        return s:NrrwRgnStatus()
    endif

    if strlen(l:mode)
        return s:BuildMode(l:mode)
    endif

    return ''
endfunction

function! s:NrrwRgnStatus() abort
    let l:parts = [ printf('%s#%d', 'NrrwRgn', b:nrrw_instn) ]

    let dict = exists('*nrrwrgn#NrrwRgnStatus()') ?  nrrwrgn#NrrwRgnStatus() : {}

    if !empty(dict)
        let fname = fnamemodify(dict.fullname, ':~:.')
        call add(l:parts, fname)
    elseif get(b:, 'orig_buf', 0)
        call add(l:parts, bufname(b:orig_buf))
    endif

    return s:BuildStatus(parts)
endfunction

function! s:ActiveStatusLine(winnum) abort
    let bufnum = winbufnr(a:winnum)

    " custom status
    let stl = s:CustomStatus(bufnum)
    if strlen(stl)
        return stl
    endif

    let l:fill_parts = []
    let l:extra_parts = []

    let l:width = winwidth(a:winnum)

    if l:width >= s:small_window_width
        let l:fill_parts = [
                    \ s:IndentationStatus(),
                    \ s:FileSizeStatus(),
                    \ ]

        let l:extra_parts = [
                    \ s:ClipboardStatus(),
                    \ s:PasteStatus(),
                    \ s:SpellStatus(),
                    \ ]
    endif

    return s:BuildStatus(
                \ [
                \   s:Strip(crystalline#mode_label()),
                \   s:FileNameStatus(bufnum, l:width - 2),
                \   s:GitBranchStatus(l:width),
                \ ],
                \ [
                \   l:width < s:xsmall_window_width ? &ft : s:FileInfoStatus(bufnum),
                \   l:fill_parts,
                \   l:extra_parts,
                \ ]
                \ )
endfunction

function! s:InactiveStatusLine(winnum) abort
    let bufnum = winbufnr(a:winnum)

    " show only custom mode in inactive buffer
    let stl = s:CustomMode(bufnum)
    if empty(stl)
        let stl = s:FileNameStatus(bufnum)
    endif

    " plugin/crystalline_settings.vim[+]
    return s:Hi('CrystallineInactive') . ' ' . stl . ' '
endfunction

function! StatusLine(current, win) abort
    let winnum = win_id2win(a:win)

    let l:current = a:current
    if winnum == winnr() && !l:current
        let l:current = 1
    endif

    if l:current
        return s:ActiveStatusLine(winnum)
    else
        return s:InactiveStatusLine(winnum)
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

" CtrlP Integration
let g:ctrlp_status_func = {
            \ 'main': 'CtrlPMainStatusLine',
            \ 'prog': 'CtrlPProgressStatusLine',
            \ }

function! CtrlPMainStatusLine(focus, byfname, regex, prev, item, next, marked) abort
    return s:BuildStatus(
                \ [
                \   s:filetype_modes['ControlP'],
                \   [ a:prev, printf(' « %s » ', a:item), a:next],
                \ ],
                \ [
                \   s:GetCurrentDir(),
                \   a:byfname,
                \   a:focus,
                \ ])
endfunction

function! CtrlPProgressStatusLine(len) abort
    return s:BuildStatus([ a:len ], [ s:GetCurrentDir() ])
endfunction

" Tagbar Integration
let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
    if empty(a:flags)
        return s:BuildStatus([a:sort, a:fname])
    else
        return s:BuildStatus([a:sort, a:fname, printf('[%s]', join(a:flags, ''))])
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
