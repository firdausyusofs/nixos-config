local awful = require "awful"
local beautiful = require "beautiful"
local hotkeys_popup = require "awful.hotkeys_popup"

-- Load Debian menu entries
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- Create a launcher widget and a main menu
local my_awesome_menu = {
  {
    "hotkeys",
    function()
      hotkeys_popup.show_help(nil, awful.screen.focused())
    end,
  },
  { "edit config", "nvim " .. awesome.conffile },
  { "restart", awesome.restart },
  {
    "quit",
    function()
      awesome.quit()
    end,
  },
}

local menu_awesome = { "awesome", my_awesome_menu, beautiful.awesome_icon }

local my_main_menu
if has_fdo then
  my_main_menu = freedesktop.menu.build { before = { menu_awesome } }
else
  my_main_menu = awful.menu {
    items = {
      menu_awesome,
    },
  }
end

return my_main_menu
