if exists('g:loaded_vim_crystalline_settings') || v:version < 700
    finish
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

function! s:hi(group)
    return printf('%%#%s#', a:group)
endfunction

function! s:GetCurrentDir() abort
    let dir = fnamemodify(getcwd(), ':~:.')
    if empty(dir)
        let dir = getcwd()
    endif
    return dir
endfunction

function! s:CrystallineFileFormat() abort
    if &fileformat ==# 'unix'
        return ''
    endif
    return &fileformat
endfunction

function! s:CrystallineFileEncoding(...) abort
    let l:encoding = &fileencoding !=# '' ? &fileencoding : &encoding
    if l:encoding ==? 'utf-8'
        return ''
    endif
    return printf(get(a:, 1, 0) ? '[%s]' : '%s', l:encoding)
endfunction

function! CrystallineFileInfo() abort
    let has_devicons = exists('*WebDevIconsGetFileTypeSymbol') && exists('*WebDevIconsGetFileFormatSymbol')

    if has_devicons
        let parts = s:RemoveEmptyElement([
                    \ s:CrystallineFileSize(),
                    \ s:CrystallineFileEncoding(1),
                    \ WebDevIconsGetFileFormatSymbol() . ' ',
                    \ &filetype,
                    \ WebDevIconsGetFileTypeSymbol() . ' ',
                    \ ])
        return join(parts, ' ')
    else
        let parts = s:RemoveEmptyElement([
                    \ s:CrystallineFileEncoding(),
                    \ s:CrystallineFileFormat(),
                    \ &filetype,
                    \ ])

        if empty(parts)
            return ''
        endif

        if len(parts) == 1
            return s:strip('' . s:CrystallineFileSize() . ' ' . parts[0])
        endif

        call insert(parts, s:CrystallineFileSize(), 0)

        return s:strip(join(parts, ' | '))
    endif
endfunction

function! s:CrystallineSpacesOrTabSize() abort
    let shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    return printf(' %s: %d ', (&expandtab ? 'Spaces' : 'Tab Size'), shiftwidth)
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

function! s:CrystallineFileSize() abort
    if g:crystalline_enable_file_size
        return s:FileSize()
    endif
    return ''
endfunction

function! s:CrystallinePasteOrSpell() abort
    let l:parts = []

    if &paste
        call add(l:parts, '[PASTE]')
    endif

    if &spell
        call add(l:parts, printf('[SPELL %s]', toupper(substitute(&spelllang, ',', '/', 'g'))))
    endif

    if len(l:parts)
        return ' ' . join(l:parts, ' ') . ' '
    endif

    return ''
endfunction

function! s:GetClipboardStatus() abort
    if match(&clipboard, 'unnamed') > -1
        return '@'
    endif
    return ''
endfunction

function! s:RemoveEmptyElement(list) abort
    return filter(copy(a:list), '!empty(v:val)')
endfunction

function! s:GetBufferType(bufnum) abort
    let ft = getbufvar(a:bufnum, '&filetype')

    if empty(ft)
        let ft = getbufvar(a:bufnum, '&buftype')
    endif

    return ft
endfunction

function! s:BuildCustomMode(...) abort
    let l:mode = add(copy(a:000), s:GetClipboardStatus())
    let l:mode = join(s:RemoveEmptyElement(l:mode), ' ')
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

function! s:CrystallineCustomMode() abort
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

function! s:IsCustomMode() abort
    let ft = s:GetBufferType('%')
    let fname = fnamemodify(bufname('%'), ':t')
    return has_key(s:filetype_modes, ft) || has_key(s:filename_modes, fname)
endfunction

function! s:IsSmallWindow(winnum) abort
    return winwidth(a:winnum) < s:small_window_width
endfunction

function! s:IsNormalWindow(winnum) abort
    return winwidth(a:winnum) >= s:normal_window_width
endfunction

function! s:BranchShorten(branch, length)
    let branch = a:branch

    if strlen(branch) > a:length
        let branch = pathshorten(branch)
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
        return s:BranchShorten(a:branch, 50)
    endif

    return s:BranchShorten(a:branch, 30)
endfunction

function! CrystallineBranch() abort
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

function! StatusLine(current, width)
    let l:s = ''

    if a:current && s:IsCustomMode()
        return s:CrystallineCustomMode()
    endif

    if a:current
        let l:s .= crystalline#mode() . s:GetClipboardStatus() . crystalline#right_mode_sep('')
    else
        let l:s .= s:hi('CrystallineInactive')
    endif
    let l:s .= ' %f%h%w%m%r '

    if a:current
        let l:s .= crystalline#right_sep('', 'Fill') . ' %{CrystallineBranch()}'
    endif

    let l:s .= '%='
    if a:current

        let l:s .= s:CrystallinePasteOrSpell()
        let l:s .= crystalline#left_sep('', 'Fill')
        let l:s .= s:CrystallineSpacesOrTabSize()
        let l:s .= crystalline#left_mode_sep('')

        if a:width > s:small_window_width
            let l:s .= ' %{CrystallineFileInfo()}'
        endif
    endif

    let l:s .= ' '

    return l:s
endfunction

function! TabLine()
    let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
    return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=' . s:hi('CrystallineTab') . l:vimlabel
endfunction

let g:crystalline_statusline_fn    = 'StatusLine'
let g:crystalline_tabline_fn       = 'TabLine'

" CtrlP Integration
let g:ctrlp_status_func = {
            \ 'main': 'CtrlPMainStatusLine',
            \ 'prog': 'CtrlPProgressStatusLine',
            \ }

function! CtrlPMainStatusLine(focus, byfname, regex, prev, item, next, marked) abort
    let item = s:hi('CrystallineNormalModeToLine') . 
                \ s:hi('Character') . ' « ' . a:item . ' » %*' .
                \ s:hi('Crystalline')
    let dir  = s:GetCurrentDir()
    return s:BuildCustomStatus('CtrlP', join([a:prev, item, a:next]), s:strip(a:marked)) . printf(' %%=%%<%s %s %s %s %s ',
                \ a:focus,
                \ crystalline#left_sep('', 'Fill'),
                \ a:byfname,
                \ crystalline#left_mode_sep(''),
                \ dir)
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

function! ZoomWinStatusLine(zoomstate) abort
    for F in s:ZoomWin_funcref
        if type(F) == 2 && F != function('ZoomWinStatusLine')
            call F(a:zoomstate)
        endif
    endfor
endfunction

let g:ZoomWin_funcref= function('ZoomWinStatusLine')
