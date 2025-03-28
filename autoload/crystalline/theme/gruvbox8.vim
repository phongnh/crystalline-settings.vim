function! crystalline#theme#gruvbox8#SetTheme() abort
    if &background ==# 'dark'
        call crystalline#GenerateTheme({
                    \ 'A':                [['235', '137'], ['#282828', '#a89984'], ''],
                    \ 'B':                [['137', '239'], ['#a89984', '#504945'], ''],
                    \ 'Fill':             [['137', '237'], ['#a89984', '#3c3836'], ''],
                    \ 'Fill1':            [['109', '237'], ['#83a598', '#3c3836'], ''],
                    \ 'Tab1':             [['109', '237'], ['#83a598', '#3c3836'], ''],
                    \ 'InactiveA':        [['243', '237'], ['#7c6f64', '#3c3836'], ''],
                    \ 'InactiveB':        [['243', '237'], ['#7c6f64', '#3c3836'], ''],
                    \ 'InactiveFill':     [['243', '237'], ['#7c6f64', '#3c3836'], ''],
                    \ 'InactiveFill1':    [['109', '237'], ['#83a598', '#3c3836'], ''],
                    \ 'NormalModeFill1':  [['109', '237'], ['#83a598', '#3c3836'], ''],
                    \ 'NormalModeTab1':   [['109', '237'], ['#83a598', '#3c3836'], ''],
                    \ 'CommandModeTab1':  [['109', '237'], ['#83a598', '#3c3836'], ''],
                    \ 'InsertModeA':      [['235', '109'], ['#282828', '#83a598'], ''],
                    \ 'InsertModeFill':   [['187', '239'], ['#ebdbb2', '#504945'], ''],
                    \ 'InsertModeFill1':  [['109', '239'], ['#83a598', '#504945'], ''],
                    \ 'InsertModeTab1':   [['109', '237'], ['#83a598', '#3c3836'], ''],
                    \ 'VisualModeA':      [['235', '208'], ['#282828', '#fe8019'], ''],
                    \ 'VisualModeFill':   [['235', '243'], ['#282828', '#7c6f64'], ''],
                    \ 'VisualModeTab1':   [['109', '237'], ['#83a598', '#3c3836'], ''],
                    \ 'ReplaceModeA':     [['235', '107'], ['#282828', '#8ec07c'], ''],
                    \ 'ReplaceModeFill':  [['187', '239'], ['#ebdbb2', '#504945'], ''],
                    \ 'ReplaceModeFill1': [['109', '239'], ['#83a598', '#504945'], ''],
                    \ 'ReplaceModeTab1':  [['109', '237'], ['#83a598', '#3c3836'], ''],
                    \ 'TerminalModeTab1': [['109', '237'], ['#83a598', '#3c3836'], ''],
                    \ })
    else
        call crystalline#GenerateTheme({
                    \ 'A':                [['230', '243'], ['#fbf1c7', '#7c6f64'], ''],
                    \ 'B':                [['243', '187'], ['#7c6f64', '#d5c4a1'], ''],
                    \ 'Fill':             [['243', '187'], ['#7c6f64', '#ebdbb2'], ''],
                    \ 'Fill1':            [['23',  '187'], ['#076678', '#ebdbb2'], ''],
                    \ 'Tab1':             [['23',  '187'], ['#076678', '#ebdbb2'], ''],
                    \ 'InactiveA':        [['137', '187'], ['#a89984', '#ebdbb2'], ''],
                    \ 'InactiveB':        [['137', '187'], ['#a89984', '#ebdbb2'], ''],
                    \ 'InactiveFill':     [['137', '187'], ['#a89984', '#ebdbb2'], ''],
                    \ 'InactiveFill1':    [['23',  '187'], ['#076678', '#ebdbb2'], ''],
                    \ 'NormalModeFill1':  [['23',  '187'], ['#076678', '#ebdbb2'], ''],
                    \ 'NormalModeTab1':   [['23',  '187'], ['#076678', '#ebdbb2'], ''],
                    \ 'CommandModeTab1':  [['23',  '187'], ['#076678', '#ebdbb2'], ''],
                    \ 'InsertModeA':      [['230', '23'],  ['#fbf1c7', '#076678'], ''],
                    \ 'InsertModeFill':   [['237', '187'], ['#3c3836', '#d5c4a1'], ''],
                    \ 'InsertModeFill1':  [['23',  '187'], ['#076678', '#d5c4a1'], ''],
                    \ 'InsertModeTab1':   [['23',  '187'], ['#076678', '#ebdbb2'], ''],
                    \ 'VisualModeA':      [['230', '124'], ['#fbf1c7', '#af3a03'], ''],
                    \ 'VisualModeFill':   [['230', '137'], ['#fbf1c7', '#a89984'], ''],
                    \ 'VisualModeTab1':   [['23',  '187'], ['#076678', '#ebdbb2'], ''],
                    \ 'ReplaceModeA':     [['230', '29'],  ['#fbf1c7', '#427b58'], ''],
                    \ 'ReplaceModeFill':  [['237', '187'], ['#3c3836', '#d5c4a1'], ''],
                    \ 'ReplaceModeFill1': [['23',  '187'], ['#076678', '#d5c4a1'], ''],
                    \ 'ReplaceModeTab1':  [['23',  '187'], ['#076678', '#ebdbb2'], ''],
                    \ 'TerminalModeTab1': [['23',  '187'], ['#076678', '#ebdbb2'], ''],
                    \ })
    endif
endfunction
