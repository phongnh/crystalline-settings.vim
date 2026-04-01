function! crystalline#theme#gruvbox_material#SetTheme() abort
  if &background ==# 'dark'
    call crystalline#GenerateTheme({
          \ 'A':                [['234', '246'], ['#1d2021', '#a89984'], ''],
          \ 'B':                [['223', '239'], ['#ddc7a1', '#504945'], ''],
          \ 'Fill':             [['223', '235'], ['#ddc7a1', '#282828'], ''],
          \ 'Fill1':            [['109', '235'], ['#7daea3', '#282828'], ''],
          \ 'InactiveA':        [['246', '235'], ['#a89984', '#282828'], ''],
          \ 'InactiveB':        [['246', '235'], ['#a89984', '#282828'], ''],
          \ 'InactiveFill':     [['246', '235'], ['#a89984', '#282828'], ''],
          \ 'NormalModeFill1':  [['109', '235'], ['#7daea3', '#282828'], ''],
          \ 'CommandModeA':     [['234', '109'], ['#1d2021', '#7daea3'], ''],
          \ 'CommandModeFill1': [['109', '235'], ['#7daea3', '#282828'], ''],
          \ 'InsertModeA':      [['234', '142'], ['#1d2021', '#a9b665'], ''],
          \ 'InsertModeFill1':  [['109', '235'], ['#7daea3', '#282828'], ''],
          \ 'VisualModeA':      [['234', '167'], ['#1d2021', '#ea6962'], ''],
          \ 'VisualModeFill1':  [['109', '235'], ['#7daea3', '#282828'], ''],
          \ 'ReplaceModeA':     [['234', '214'], ['#1d2021', '#d8a657'], ''],
          \ 'ReplaceModeFill1': [['109', '235'], ['#7daea3', '#282828'], ''],
          \ })
  else
    call    crystalline#GenerateTheme({
          \ 'A':                [['230', '243'], ['#f9f5d7', '#7c6f64'], ''],
          \ 'B':                [['237', '250'], ['#4f3829', '#eee0b7'], ''],
          \ 'Fill':             [['237', '223'], ['#4f3829', '#f5edca'], ''],
          \ 'Fill1':            [['24',  '223'], ['#45707a', '#f5edca'], ''],
          \ 'InactiveA':        [['243', '223'], ['#7c6f64', '#f5edca'], ''],
          \ 'InactiveB':        [['243', '223'], ['#7c6f64', '#f5edca'], ''],
          \ 'InactiveFill':     [['243', '223'], ['#7c6f64', '#f5edca'], ''],
          \ 'NormalModeFill1':  [['24',  '223'], ['#45707a', '#f5edca'], ''],
          \ 'CommandModeA':     [['230', '24'],  ['#f9f5d7', '#45707a'], ''],
          \ 'CommandModeFill1': [['24',  '223'], ['#45707a', '#f5edca'], ''],
          \ 'InsertModeA':      [['230', '100'], ['#f9f5d7', '#6f8352'], ''],
          \ 'InsertModeFill1':  [['24',  '223'], ['#45707a', '#f5edca'], ''],
          \ 'VisualModeA':      [['230', '88'],  ['#f9f5d7', '#ae5858'], ''],
          \ 'VisualModeFill1':  [['24',  '223'], ['#45707a', '#f5edca'], ''],
          \ 'ReplaceModeA':     [['230', '130'], ['#f9f5d7', '#a96b2c'], ''],
          \ 'ReplaceModeFill1': [['24',  '223'], ['#45707a', '#f5edca'], ''],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
