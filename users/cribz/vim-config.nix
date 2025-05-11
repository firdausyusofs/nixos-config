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
require('Comment').setup()
require("octo").setup()

-- vim.opt.termsync = false

-- vim.cmd [[
--   highlight Normal guibg=none
--   highlight NonText guibg=none
--   highlight Normal ctermbg=none
--   highlight NonText ctermbg=none
-- ]]

-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = { "lua", "bash", "c", "python" },
--                    highlight = { enable = true }
-- }

---------------------------------------------------------------------
-- CodeCompanion

require("codecompanion").setup({
  adapters = {
    gemini = function()
      return require("codecompanion.adapters").extend("gemini", {
        env = {
          --api_key = "cmd:op read op://Private/Gemini_API/credential --no-newline",
        },
        schema = {
          model = {
            -- default = "gemini-2.5-pro-exp-03-25",
            default = "gemini-2.5-flash-preview-04-17",
          },
        },
      })
    end,
  },
  display = {
    chat = {
      show_header_separator = true,
      -- show_settings = true,
      show_references = true,
      show_token_count = true,
      window = {
        opts = {
          number = false,
          signcolumn = "no",
        },
      },
    },
  },
  strategies = {
    chat = {
      adapter = "gemini",
      keymaps = {
        completion = {
          modes = { i = "<C-/>" },
          callback = "keymaps.completion",
          description = "Completion Menu",
        }
      }
    },
    inline = {
      adapter = "gemini",
    },
  },
})
vim.keymap.set(
  { "n", "v" },
  "<C-a>",
  "<cmd>CodeCompanionActions<cr>",
  { noremap = true, silent = true }
)
vim.keymap.set(
  { "n" },
  "<C-c>",
  "<cmd>CodeCompanionChat Toggle<cr>",
  { noremap = true, silent = true }
)
vim.keymap.set(
  { "v" },
  "<C-c>",
  "<cmd>CodeCompanionChat Add<cr>",
  { noremap = true, silent = true }
)

EOF
''

