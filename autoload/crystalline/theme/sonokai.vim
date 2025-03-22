function! crystalline#theme#sonokai#SetTheme() abort
    call crystalline#GenerateTheme({
                \ 'A':                [['235', '110'], ['#2c2e34', '#85d3f2'], ''],
                \ 'B':                [['250', '237'], ['#e2e2e3', '#414550'], ''],
                \ 'Fill':             [['250', '236'], ['#e2e2e3', '#33353f'], ''],
                \ 'Fill1':            [['110', '236'], ['#76cce0', '#33353f'], ''],
                \ 'InactiveA':        [['246', '236'], ['#7f8490', '#33353f'], ''],
                \ 'InactiveB':        [['246', '236'], ['#7f8490', '#33353f'], ''],
                \ 'InactiveFill':     [['246', '236'], ['#7f8490', '#33353f'], ''],
                \ 'NormalModeFill1':  [['110', '236'], ['#76cce0', '#33353f'], ''],
                \ 'CommandModeA':     [['235', '215'], ['#2c2e34', '#f39660'], ''],
                \ 'CommandModeFill1': [['215', '236'], ['#f39660', '#33353f'], ''],
                \ 'InsertModeA':      [['235', '107'], ['#2c2e34', '#a7df78'], ''],
                \ 'InsertModeFill1':  [['107', '236'], ['#9ed072', '#33353f'], ''],
                \ 'VisualModeA':      [['235', '176'], ['#2c2e34', '#b39df3'], ''],
                \ 'VisualModeFill1':  [['176', '236'], ['#b39df3', '#33353f'], ''],
                \ 'ReplaceModeA':     [['235', '179'], ['#2c2e34', '#e7c664'], ''],
                \ 'ReplaceModeFill1': [['179', '236'], ['#e7c664', '#33353f'], ''],
                \ })
endfunction
