function! crystalline#theme#gotham#SetTheme() abort
    call crystalline#GenerateTheme({
                \ 'A':                 [[7, 4], ['#99d1ce', '#195466'], ''],
                \ 'B':                 [[14, 10], ['#599cab', '#091f2e'], ''],
                \ 'Fill':              [[4, 8], ['#195466', '#11151c'], ''],
                \ 'Fill1':             [[13, 8], ['#888ca6', '#11151c'], ''],
                \ 'Tab1':              [[13, 8], ['#888ca6', '#0c1014'], ''],
                \ 'InactiveA':         [[4, 10], ['#195466', '#091f2e'], ''],
                \ 'InactiveB':         [[4, 8], ['#195466', '#11151c'], ''],
                \ 'InactiveFill':      [[4, 8], ['#195466', '#0c1014'], ''],
                \ 'InactiveFill1':     [[13, 8], ['#888ca6', '#0c1014'], ''],
                \ 'NormalModeFill1':   [[13, 8], ['#888ca6', '#11151c'], ''],
                \ 'NormalModeTab1':    [[13, 8], ['#888ca6', '#0c1014'], ''],
                \ 'CommandModeTab1':   [[13, 8], ['#888ca6', '#0c1014'], ''],
                \ 'InsertModeA':       [[10, 3], ['#091f2e', '#edb443'], ''],
                \ 'InsertModeA2':      [[10, 9], ['#091f2e', '#d26937'], ''],
                \ 'InsertModeB':       [[7, 12], ['#99d1ce', '#0a3749'], ''],
                \ 'InsertModeFill1':   [[13, 8], ['#888ca6', '#11151c'], ''],
                \ 'InsertModeTab1':    [[13, 8], ['#888ca6', '#0c1014'], ''],
                \ 'InsertModeTabSel2': [[10, 9], ['#091f2e', '#d26937'], ''],
                \ 'VisualModeA':       [[10, 13], ['#091f2e', '#888ca6'], ''],
                \ 'VisualModeB':       [[7, 12], ['#99d1ce', '#0a3749'], ''],
                \ 'VisualModeFill1':   [[13, 8], ['#888ca6', '#11151c'], ''],
                \ 'VisualModeTab1':    [[13, 8], ['#888ca6', '#0c1014'], ''],
                \ 'ReplaceModeA':      [[10, 9], ['#091f2e', '#d26937'], ''],
                \ 'ReplaceModeB':      [[7, 12], ['#99d1ce', '#0a3749'], ''],
                \ 'ReplaceModeFill1':  [[13, 8], ['#888ca6', '#11151c'], ''],
                \ 'ReplaceModeTab1':   [[13, 8], ['#888ca6', '#0c1014'], ''],
                \ 'TerminalModeA':     [[10, 3], ['#091f2e', '#edb443'], ''],
                \ 'TerminalModeB':     [[7, 12], ['#99d1ce', '#0a3749'], ''],
                \ 'TerminalModeTab1':  [[13, 8], ['#888ca6', '#0c1014'], ''],
                \ })
endfunction
