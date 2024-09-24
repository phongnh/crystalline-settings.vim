" https://github.com/nvim-neo-tree/neo-tree.nvim
function! crystalline_settings#neotree#Mode(...) abort
    return { 'plugin': exists('b:neo_tree_source') ? b:neo_tree_source : '' }
endfunction

