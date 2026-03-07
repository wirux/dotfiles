return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "debugloop/telescope-undo.nvim",
    },
    keys = {
      { "<C-u>", "<cmd>Telescope undo<cr>", desc = "Telescope Undo" },
      { "<leader>,", "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<cr>", desc = "Switch Buffer" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          path_display = { "smart" },
        },
        extensions = {
          undo = {
            mappings = {
              i = {
                ["<CR>"] = require("telescope-undo.actions").restore,
                ["<S-CR>"] = function(prompt_bufnr)
                  return function()
                    require("telescope-undo.actions").restore(prompt_bufnr)()
                    vim.cmd("undo")
                  end
                end,
              },
              n = {
                ["<CR>"] = require("telescope-undo.actions").restore,
                ["<S-CR>"] = function(prompt_bufnr)
                  return function()
                    require("telescope-undo.actions").restore(prompt_bufnr)()
                    vim.cmd("undo")
                  end
                end,
              },
            },
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            },
          },
        },
      })
    end,
  },
}
