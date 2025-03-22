function! crystalline#theme#edge#SetTheme() abort
    if &background ==# 'dark'
        call crystalline#GenerateTheme({
                    \ 'A':                [['235', '107'], ['#2b2d3a', '#a0c980'], ''],
                    \ 'B':                [['250', '238'], ['#97a4b5', '#3f445b'], ''],
                    \ 'Fill':             [['250', '236'], ['#97a4b5', '#333648'], ''],
                    \ 'Fill1':            [['107', '236'], ['#a0c980', '#333648'], ''],
                    \ 'InactiveA':        [['250', '236'], ['#97a4b5', '#333648'], ''],
                    \ 'InactiveB':        [['250', '236'], ['#97a4b5', '#333648'], ''],
                    \ 'NormalModeFill1':  [['107', '236'], ['#a0c980', '#333648'], ''],
                    \ 'CommandModeA':     [['235', '203'], ['#2b2d3a', '#ec7279'], ''],
                    \ 'CommandModeFill1': [['203', '236'], ['#ec7279', '#333648'], ''],
                    \ 'InsertModeA':      [['235', '110'], ['#2b2d3a', '#6cb6eb'], ''],
                    \ 'InsertModeFill1':  [['110', '236'], ['#6cb6eb', '#333648'], ''],
                    \ 'VisualModeA':      [['235', '203'], ['#2b2d3a', '#ec7279'], ''],
                    \ 'VisualModeFill1':  [['203', '236'], ['#ec7279', '#333648'], ''],
                    \ 'ReplaceModeA':     [['235', '179'], ['#2b2d3a', '#deb974'], ''],
                    \ 'ReplaceModeFill1': [['179', '236'], ['#deb974', '#333648'], ''],
                    \ })
    else
        call crystalline#GenerateTheme({
                    \ 'A':                [['231', '107'], ['#fafafa', '#76af6f'], ''],
                    \ 'B':                [['240', '253'], ['#4b505b', '#dde2e7'], ''],
                    \ 'Fill':             [['240', '255'], ['#4b505b', '#eef1f4'], ''],
                    \ 'Fill1':            [['107', '255'], ['#608e32', '#eef1f4'], ''],
                    \ 'InactiveA':        [['240', '255'], ['#4b505b', '#eef1f4'], ''],
                    \ 'InactiveB':        [['240', '255'], ['#4b505b', '#eef1f4'], ''],
                    \ 'NormalModeFill1':  [['107', '255'], ['#608e32', '#eef1f4'], ''],
                    \ 'CommandModeA':     [['231', '167'], ['#fafafa', '#e17373'], ''],
                    \ 'CommandModeFill1': [['167', '255'], ['#d05858', '#eef1f4'], ''],
                    \ 'InsertModeA':      [['231', '68'], ['#fafafa', '#6996e0'], ''],
                    \ 'InsertModeFill1':  [['68', '255'], ['#5079be', '#eef1f4'], ''],
                    \ 'VisualModeA':      [['231', '167'], ['#fafafa', '#e17373'], ''],
                    \ 'VisualModeFill1':  [['167', '255'], ['#d05858', '#eef1f4'], ''],
                    \ 'ReplaceModeA':     [['231', '172'], ['#fafafa', '#be7e05'], ''],
                    \ 'ReplaceModeFill1': [['172', '255'], ['#be7e05', '#eef1f4'], ''],
                    \ })
    endif
endfunction
