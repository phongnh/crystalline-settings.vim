function! crystalline#theme#everforest#SetTheme() abort
  if &background ==# 'dark'
    call crystalline#GenerateTheme({
          \ 'A':                [['235', '142'],  ['#272e33', '#a7c080'], ''],
          \ 'B':                [['247', '238'],  ['#9da9a0', '#414b50'], ''],
          \ 'Fill':             [['245', 'NONE'], ['#859289', 'NONE'],    ''],
          \ 'Fill1':            [['142', 'NONE'], ['#a7c080', 'NONE'],    ''],
          \ 'InactiveA':        [['245', 'NONE'], ['#859289', 'NONE'],    ''],
          \ 'InactiveB':        [['245', 'NONE'], ['#859289', 'NONE'],    ''],
          \ 'NormalModeFill1':  [['142', 'NONE'], ['#a7c080', 'NONE'],    ''],
          \ 'CommandModeA':     [['235', '108'],  ['#272e33', '#83c092'], ''],
          \ 'CommandModeFill1': [['108', 'NONE'], ['#83c092', 'NONE'],    ''],
          \ 'InsertModeA':      [['235', '223'],  ['#272e33', '#d3c6aa'], ''],
          \ 'InsertModeB':      [['223', '238'],  ['#d3c6aa', '#414b50'], ''],
          \ 'InsertModeFill':   [['223', 'NONE'], ['#d3c6aa', 'NONE'],    ''],
          \ 'VisualModeA':      [['235', '167'],  ['#272e33', '#e67e80'], ''],
          \ 'VisualModeFill1':  [['167', 'NONE'], ['#e67e80', 'NONE'],    ''],
          \ 'ReplaceModeA':     [['235', '208'],  ['#272e33', '#e69875'], ''],
          \ 'ReplaceModeFill1': [['208', 'NONE'], ['#e69875', 'NONE'],    ''],
          \ })
  else
    call crystalline#GenerateTheme({
          \ 'A':                [['230', '106'],  ['#fffbef', '#93b259'], ''],
          \ 'B':                [['247', '223'],  ['#829181', '#edeada'], ''],
          \ 'Fill':             [['247', 'NONE'], ['#939f91', 'NONE'],    ''],
          \ 'Fill1':            [['106', 'NONE'], ['#8da101', 'NONE'],    ''],
          \ 'InactiveA':        [['247', 'NONE'], ['#939f91', 'NONE'],    ''],
          \ 'InactiveB':        [['247', 'NONE'], ['#939f91', 'NONE'],    ''],
          \ 'NormalModeFill1':  [['106', 'NONE'], ['#8da101', 'NONE'],    ''],
          \ 'CommandModeA':     [['230', '37'],   ['#fffbef', '#35a77c'], ''],
          \ 'CommandModeFill1': [['37',  'NONE'], ['#35a77c', 'NONE'],    ''],
          \ 'InsertModeA':      [['230', '242'],  ['#fffbef', '#708089'], ''],
          \ 'InsertModeB':      [['242', '223'],  ['#5c6a72', '#edeada'], ''],
          \ 'InsertModeFill':   [['242', 'NONE'], ['#5c6a72', 'NONE'],    ''],
          \ 'VisualModeA':      [['230', '160'],  ['#fffbef', '#e66868'], ''],
          \ 'VisualModeFill1':  [['160', 'NONE'], ['#f85552', 'NONE'],    ''],
          \ 'ReplaceModeA':     [['230', '116'],  ['#fffbef', '#f57d26'], ''],
          \ 'ReplaceModeFill1': [['116', 'NONE'], ['#f57d26', 'NONE'],    ''],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
