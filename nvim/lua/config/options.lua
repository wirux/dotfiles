-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Ensure UTF-8 encoding is used
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Explicitly configure the clipboard provider to use UTF-8 on macOS
-- This fixes issues where copied text appears as "≈Ç" (MacRoman) and pasted text has "?"
if vim.fn.has("macunix") == 1 then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "env LANG=en_US.UTF-8 pbcopy",
      ["*"] = "env LANG=en_US.UTF-8 pbcopy",
    },
    paste = {
      ["+"] = "env LANG=en_US.UTF-8 pbpaste",
      ["*"] = "env LANG=en_US.UTF-8 pbpaste",
    },
    cache_enabled = 0,
  }
end
