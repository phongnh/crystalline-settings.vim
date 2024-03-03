function! crystalline#theme#gruvbox_community#SetTheme() abort
  if &background ==# 'dark'
    call crystalline#GenerateTheme({
          \ 'A':                [['234', '246'], ['#1d2021', '#a89984'], ''],
          \ 'B':                [['246', '239'], ['#a89984', '#504945'], ''],
          \ 'Fill':             [['246', '237'], ['#a89984', '#3c3836'], ''],
          \ 'Fill1':            [['223', '237'], ['#ebdbb2', '#3c3836'], ''],
          \ 'Tab1':             [['223', '237'], ['#ebdbb2', '#3c3836'], ''],
          \ 'InactiveA':        [['243', '237'], ['#7c6f64', '#3c3836'], ''],
          \ 'InactiveB':        [['243', '237'], ['#7c6f64', '#3c3836'], ''],
          \ 'InactiveFill':     [['243', '237'], ['#7c6f64', '#3c3836'], ''],
          \ 'InactiveFill1':    [['223', '237'], ['#ebdbb2', '#3c3836'], ''],
          \ 'NormalModeFill1':  [['223', '237'], ['#ebdbb2', '#3c3836'], ''],
          \ 'NormalModeTab1':   [['223', '237'], ['#ebdbb2', '#3c3836'], ''],
          \ 'CommandModeA':     [['234', '142'], ['#1d2021', '#b8bb26'], ''],
          \ 'CommandModeFill':  [['223', '239'], ['#ebdbb2', '#504945'], ''],
          \ 'CommandModeTab1':  [['223', '237'], ['#ebdbb2', '#3c3836'], ''],
          \ 'InsertModeA':      [['234', '223'], ['#1d2021', '#ebdbb2'], ''],
          \ 'InsertModeFill':   [['223', '239'], ['#ebdbb2', '#504945'], ''],
          \ 'InsertModeTab1':   [['223', '237'], ['#ebdbb2', '#3c3836'], ''],
          \ 'VisualModeA':      [['234', '208'], ['#1d2021', '#fe8019'], ''],
          \ 'VisualModeFill':   [['234', '243'], ['#1d2021', '#7c6f64'], ''],
          \ 'VisualModeTab1':   [['223', '237'], ['#ebdbb2', '#3c3836'], ''],
          \ 'ReplaceModeA':     [['234', '214'], ['#1d2021', '#fabd2f'], ''],
          \ 'ReplaceModeFill':  [['223', '239'], ['#ebdbb2', '#504945'], ''],
          \ 'ReplaceModeTab1':  [['223', '237'], ['#ebdbb2', '#3c3836'], ''],
          \ 'TerminalModeTab1': [['223', '237'], ['#ebdbb2', '#3c3836'], ''],
          \ })
  else
    call crystalline#GenerateTheme({
          \ 'A':                [['230', '243'], ['#f9f5d7', '#7c6f64'], ''],
          \ 'B':                [['243', '250'], ['#7c6f64', '#d5c4a1'], ''],
          \ 'Fill':             [['243', '223'], ['#7c6f64', '#ebdbb2'], ''],
          \ 'Fill1':            [['237', '223'], ['#3c3836', '#ebdbb2'], ''],
          \ 'Tab1':             [['237', '223'], ['#3c3836', '#ebdbb2'], ''],
          \ 'InactiveA':        [['246', '223'], ['#a89984', '#ebdbb2'], ''],
          \ 'InactiveB':        [['246', '223'], ['#a89984', '#ebdbb2'], ''],
          \ 'InactiveFill':     [['246', '223'], ['#a89984', '#ebdbb2'], ''],
          \ 'InactiveFill1':    [['237', '223'], ['#3c3836', '#ebdbb2'], ''],
          \ 'NormalModeFill1':  [['237', '223'], ['#3c3836', '#ebdbb2'], ''],
          \ 'NormalModeTab1':   [['237', '223'], ['#3c3836', '#ebdbb2'], ''],
          \ 'CommandModeA':     [['230', '100'], ['#f9f5d7', '#79740e'], ''],
          \ 'CommandModeFill':  [['237', '250'], ['#3c3836', '#d5c4a1'], ''],
          \ 'CommandModeTab1':  [['237', '223'], ['#3c3836', '#ebdbb2'], ''],
          \ 'InsertModeA':      [['230', '237'], ['#f9f5d7', '#3c3836'], ''],
          \ 'InsertModeFill':   [['237', '250'], ['#3c3836', '#d5c4a1'], ''],
          \ 'InsertModeTab1':   [['237', '223'], ['#3c3836', '#ebdbb2'], ''],
          \ 'VisualModeA':      [['230', '130'], ['#f9f5d7', '#af3a03'], ''],
          \ 'VisualModeFill':   [['230', '246'], ['#f9f5d7', '#a89984'], ''],
          \ 'VisualModeTab1':   [['237', '223'], ['#3c3836', '#ebdbb2'], ''],
          \ 'ReplaceModeA':     [['230', '136'], ['#f9f5d7', '#b57614'], ''],
          \ 'ReplaceModeFill':  [['237', '250'], ['#3c3836', '#d5c4a1'], ''],
          \ 'ReplaceModeTab1':  [['237', '223'], ['#3c3836', '#ebdbb2'], ''],
          \ 'TerminalModeTab1': [['237', '223'], ['#3c3836', '#ebdbb2'], ''],
          \ })
  endif
endfunction

" vim:set et sw=2 ts=2 fdm=marker:
