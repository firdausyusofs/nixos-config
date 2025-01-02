{ sources }:
''
"--------------------------------------------------------------------
" Fix vim paths so we load the vim-misc directory
let g:vim_home_path = "~/.vim"

" This works on NixOS 21.05
let nvim_config_path = split(&packpath, ",")[0] . "/pack/home-manager/start/nvim-config/init.lua"
if filereadable(nvim_config_path)
  execute "source " . nvim_config_path
endif

" This works on NixOS 21.11
let nvim_config_path = split(&packpath, ",")[0] . "/pack/home-manager/start/vimplugin-nvim-config/init.lua"
if filereadable(nvim_config_path)
  execute "source " . nvim_config_path
endif

" This works on NixOS 22.11
let nvim_config_path = split(&packpath, ",")[0] . "/pack/myNeovimPackages/start/vimplugin-nvim-config/init.lua"
if filereadable(nvim_config_path)
  execute "source " . nvim_config_path
endif

lua <<EOF
---------------------------------------------------------------------
-- Add our custom treesitter parsers
-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
--
-- parser_config.proto = {
--   install_info = {
--     url = "${sources.tree-sitter-proto}", -- local path or git repo
--     files = {"src/parser.c"}
--   },
--   filetype = "proto", -- if filetype does not agrees with parser name
-- }

---------------------------------------------------------------------
-- Add our treesitter textobjects
-- require'nvim-treesitter.configs'.setup {
--   textobjects = {
--     select = {
--       enable = true,
--       keymaps = {
--         -- You can use the capture groups defined in textobjects.scm
--         ["af"] = "@function.outer",
--         ["if"] = "@function.inner",
--         ["ac"] = "@class.outer",
--         ["ic"] = "@class.inner",
--       },
--     },
--
--     move = {
--       enable = true,
--       set_jumps = true, -- whether to set jumps in the jumplist
--       goto_next_start = {
--         ["]m"] = "@function.outer",
--         ["]]"] = "@class.outer",
--       },
--       goto_next_end = {
--         ["]M"] = "@function.outer",
--         ["]["] = "@class.outer",
--       },
--       goto_previous_start = {
--         ["[m"] = "@function.outer",
--         ["[["] = "@class.outer",
--       },
--       goto_previous_end = {
--         ["[M"] = "@function.outer",
--         ["[]"] = "@class.outer",
--       },
--     },
--   },
-- }
--
-- require("conform").setup({
--   formatters_by_ft = {
--     cpp = { "clang_format" },
--   },
--
--   format_on_save = {
--     lsp_fallback = true,
--   },
-- })

---------------------------------------------------------------------
-- Cinnamon

-- require('cinnamon').setup()
-- require('cinnamon').setup {
--  extra_keymaps = true,
--  override_keymaps = true,
--  scroll_limit = -1,
--}

---------------------------------------------------------------------
-- Oil

require('oil').setup()
require('oil').setup {
  columns = { "icon" },
  keymaps = {
    ["<C-h>"] = false,
    ["<M-h>"] = "actions.select_split",
  },
  view_options = {
    show_hidden = true,
  }
}

-- vim.opt.termsync = false

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

EOF
''
