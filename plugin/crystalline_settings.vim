if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    " finish
endif
let g:loaded_vim_crystalline_settings = 1

let s:save_cpo = &cpo
set cpo&vim

" Window width
let s:small_window_width  = 80
let s:normal_window_width = 100

" Symbols
let s:symbols = {
            \ 'clipboard': 'ⓒ  ',
            \ 'paste':     'Ⓟ  ',
            \ 'left':      '»',
            \ 'right':     '«',
            \ 'readonly':  '',
            \ 'ellipsis':  '…',
            \ 'mode_sep':  ' ',
            \ 'fill_sep':  ' ',
            \ }

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

let s:powerline = {
            \ 'left':      '',
            \ 'left_alt':  '',
            \ 'right':     '',
            \ 'right_alt': '',
            \ }

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
            \ 'ctrlp':             'CtrlP',
            \ 'leaderf':           'LeaderF',
            \ 'netrw':             'NetrwTree',
            \ 'nerdtree':          'NERDTree',
            \ 'startify':          'Startify',
            \ 'vim-plug':          'Plugin',
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

let g:crystalline_enable_sep       = get(g:, 'crystalline_powerline', 0)
let g:crystalline_enable_file_size = get(g:, 'crystalline_enable_file_size', 1)
let g:crystalline_theme            = 'solarized'

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
    if type(a:list) == type([])
        let l:list = deepcopy(a:list)
    else
        let l:list = [a:list]
    endif
    return l:list
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

function! s:Hi(group)
    return printf('%%#%s#', a:group)
endfunction

function! s:IsSmallWindow(winnum) abort
    return winwidth(a:winnum) < s:small_window_width
endfunction

function! s:IsNormalWindow(winnum) abort
    return winwidth(a:winnum) >= s:normal_window_width
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
        let type = getbufvar(a:bufnum, '&buftype')
    endif

    return ft
endfunction

function! s:GetFileName(winnum, bufnum) abort
    let bname = bufname(a:bufnum)

    if empty(bname)
        return '[No Name]'
    endif

    let bname = fnamemodify(bname, ':~:.')

    if s:IsSmallWindow(a:winnum)
        return fnamemodify(bname, ':t')
    endif

    let winwidth = winwidth(a:winnum) - 2

    if strlen(bname) > winwidth && (bname[0] =~ '\~\|/')
        let bname = s:ShortenPath(bname)
    endif

    if strlen(bname) > winwidth
        let bname = fnamemodify(bname, ':t')
    endif

    if strlen(bname) > 50
        let bname = s:ShortenPath(bname)
    endif

    if strlen(bname) > 50
        let bname = fnamemodify(bname, ':t')
    endif

    return bname
endfunction

function! s:GetFileFlags(bufnum) abort
    let flags = ''

    " file modified and modifiable
    if getbufvar(a:bufnum, '&modified')
        if !getbufvar(a:bufnum, '&modifiable')
            let flags .= '[-+]'
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

function! s:GetFileNameAndFlags(winnum, bufnum) abort
    return s:GetFileName(a:winnum, a:bufnum) . s:GetFileFlags(a:bufnum)
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

function! s:ShortenBranch(branch, length)
    let branch = a:branch

    if strlen(branch) > a:length
        let branch = s:ShortenPath(branch)
    endif

    if strlen(branch) > a:length
        let branch = fnamemodify(branch, ':t')
    endif

    return branch
endfunction

function! s:FormatBranch(branch) abort
    if s:IsSmallWindow(0)
        return ''
    endif

    if s:IsNormalWindow(0)
        return s:ShortenBranch(a:branch, 50)
    endif

    return s:ShortenBranch(a:branch, 30)
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
    if g:crystalline_enable_file_size
        return s:FileSize()
    endif
    return ''
endfunction

function! s:IndentationStatus() abort
    let shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    return printf(' %s: %d ', (&expandtab ? 'Spaces' : 'Tab Size'), shiftwidth)
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

function! s:FileInfoStatus() abort
    let ft = s:GetBufferType('%')

    let s:has_devicons = exists('*WebDevIconsGetFileTypeSymbol') && exists('*WebDevIconsGetFileFormatSymbol')

    if s:has_devicons
        let parts = s:RemoveEmptyElement([
                    \ s:FileSizeStatus() . printf(' %s', s:powerline.right_alt),
                    \ s:FileEncodingStatus('%'),
                    \ WebDevIconsGetFileFormatSymbol() . ' ',
                    \ ft,
                    \ WebDevIconsGetFileTypeSymbol(bufname('%')) . ' ',
                    \ ])
    else
        let parts = s:RemoveEmptyElement([
                    \ s:FileEncodingAndFormatStatus('%'),
                    \ ft,
                    \ ])
    endif

    return join(parts, ' ') . ' '
endfunction

function! CrystallineFileInfoStatus() abort
    return s:FileInfoStatus()
endfunction

function! CrystallineFileNameStatus() abort
    " %f%h%w%m%r
    return s:GetFileNameAndFlags(0, '%')
endfunction

function! CrystallineBranchStatus() abort
    if exists('*FugitiveHead')
        return s:FormatBranch(FugitiveHead())
    elseif exists('*fugitive#head')
        return s:FormatBranch(fugitive#head())
    elseif exists(':Gina') == 2
        return s:FormatBranch(gina#component#repo#branch())
    else
        return fnamemodify(getcwd(), ':t')
    endif
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

function! s:BuildStatus(left_parts, right_parts) abort
    let left_parts  = s:ParseList(a:left_parts)
    let right_parts = s:ParseList(a:right_parts)

    let stl = ''

    let stl = crystalline#mode_color() . get(left_parts, 0, '') . crystalline#right_mode_sep('')
    let stl .= join(left_parts[1:1], s:symbols.fill_sep) . crystalline#right_sep('', 'Fill')
    let stl .= join(s:ParseFillList(left_parts[2:], printf(' %s ', s:powerline.left_alt)), printf(' %s ', s:powerline.left_alt))

    let stl .= s:StatusSeparator()

    let stl .= join(s:ParseFillList(right_parts[2:], printf(' %s ', s:powerline.right_alt)), printf(' %s ', s:powerline.right_alt))
    let stl .= ' ' . crystalline#left_sep('', 'Fill') . join(right_parts[1:1], s:symbols.fill_sep)
    let stl .= crystalline#left_mode_sep('') . get(right_parts, 0, '')

    return stl
endfunction

function! s:BuildCustomMode(...) abort
    let l:mode = join(s:RemoveEmptyElement(a:000), ' ')
    return crystalline#mode_color() . ' ' . l:mode . ' ' . crystalline#right_mode_sep('')
endfunction

function! s:BuildCustomStatus(mode, ...) abort
    let stl = s:BuildCustomMode(a:mode)

    let parts = s:RemoveEmptyElement(a:000)
    if empty(parts)
        return stl
    endif

    let stl .= ' ' . parts[0] . ' ' . crystalline#right_sep('', 'Fill')

    if len(parts) == 2
        let stl .= ' ' . parts[1]
    elseif len(parts) > 2
        let stl .= '%=%<'
        let stl .= ' ' . join(parts[2:], ' ') . ' '
    endif

    return stl
endfunction

function! s:IsCustomMode() abort
    let ft = s:GetBufferType('%')
    let fname = fnamemodify(bufname('%'), ':t')
    return has_key(s:filetype_modes, ft) || has_key(s:filename_modes, fname)
endfunction

function! s:CustomStatus() abort
    let ft = s:GetBufferType('%')
    let l:bufname = bufname('%')

    if has_key(s:filetype_modes, ft)
        let l:mode = s:filetype_modes[ft]

        if ft ==# 'terminal'
            return s:BuildCustomStatus(l:mode, '%f')
        endif

        if ft ==# 'help'
            return s:BuildCustomStatus(l:mode, fnamemodify(l:bufname, ':p:~:.'))
        endif

        if ft ==# 'qf'
            let l:qf_title = get(w:, 'quickfix_title', '')
            return s:BuildCustomStatus(l:mode, l:qf_title)
        endif
    else
        let fname = fnamemodify(l:bufname, ':t')
        let l:mode = s:filename_modes[fname]

        if fname ==# '__CtrlSF__'
            return s:BuildCustomStatus(l:mode,
                        \ substitute(ctrlsf#utils#SectionB(), 'Pattern: ', '', ''),
                        \ ctrlsf#utils#SectionC(),
                        \ ctrlsf#utils#SectionX()
                        \ )
        endif

        if fname ==# '__CtrlSFPreview__'
            return s:BuildCustomStatus(l:mode,
                        \ ctrlsf#utils#PreviewSectionC(),
                        \ ctrlsf#utils#SectionX()
                        \ )
        endif
    endif

    return s:BuildCustomMode(l:mode)
endfunction

function! StatusLine(current, width)
    if a:current
        if s:IsCustomMode()
            return s:CustomStatus()
        endif

        return s:BuildStatus(
                    \ [
                    \   crystalline#mode_label(),
                    \   ' %{CrystallineFileNameStatus()} ',
                    \   ' %{CrystallineBranchStatus()}',
                    \ ],
                    \ [
                    \   a:width > s:small_window_width  ? ' %{CrystallineFileInfoStatus()}' : ' ',
                    \   s:IndentationStatus(),
                    \   [
                    \       s:ClipboardStatus(),
                    \       s:PasteStatus(),
                    \       s:SpellStatus(),
                    \   ],
                    \ ]
                    \ )
    else
        let stl = s:Hi('CrystallineInactive')
        let stl .= ' %{CrystallineFileNameStatus()} '
    endif

    return stl
endfunction

function! TabLine()
    let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
    return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=' . s:Hi('CrystallineTab') . l:vimlabel
endfunction

let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn    = 'TabLine'

" CtrlP Integration
let g:ctrlp_status_func = {
            \ 'main': 'CtrlPMainStatusLine',
            \ 'prog': 'CtrlPProgressStatusLine',
            \ }

function! CtrlPMainStatusLine(focus, byfname, regex, prev, item, next, marked) abort
    let item = s:Hi('CrystallineNormalModeToLine') .
                \ s:Hi('Character') . ' « ' . a:item . ' » %*' .
                \ s:Hi('Crystalline')
    return s:BuildStatus(
                \ [
                \   ' ' . s:filetype_modes['ctrlp'] . ' ',
                \   join([ ' '. a:prev, item, a:next . ' ' ], ' '),
                \   ' ' . a:marked,
                \ ],
                \ [
                \   ' ' . s:GetCurrentDir() . ' ',
                \   ' ' . a:byfname . ' ',
                \   ' ' . a:focus,
                \ ])
endfunction

function! CtrlPProgressStatusLine(len) abort
    return printf(' %s %%=%%< %s ', a:len, s:GetCurrentDir())
endfunction

" Tagbar Integration
let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
    if empty(a:flags)
        return s:BuildCustomStatus(a:sort, a:fname)
    else
        return s:BuildCustomStatus(a:sort, a:fname, printf('[%s]', join(a:flags, '')))
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
