return {
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      processor = "magick_cli", -- Using magick_cli can be more stable than the Lua ffi bindings
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "quarto" },
        },
        neorg = { enabled = true },
      },
      max_width = 80,
      max_height = 15,
      max_height_window_percentage = 40,
      max_width_window_percentage = 80,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are plugin variables to be set before the plugin loads
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("quarto").setup({
        lspFeatures = {
          languages = { "python" },
          chunks = "all",
          diagnostics = { enabled = true },
          completion = { enabled = true },
        },
        codeRunner = {
          enabled = true,
          default_method = "molten",
        },
      })
    end,
  },
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      if not opts.mappings then opts.mappings = {} end
      if not opts.mappings.n then opts.mappings.n = {} end
      local maps = opts.mappings.n

      maps["<Leader>j"] = { desc = "󱗘 Jupyter" }
      maps["<Leader>ji"] = { "<cmd>MoltenInit<cr>", desc = "Initialize Molten" }
      maps["<Leader>je"] = { "<cmd>MoltenEvaluateOperator<cr>", desc = "Evaluate Operator" }
      maps["<Leader>jl"] = { "<cmd>MoltenEvaluateLine<cr>", desc = "Evaluate Line" }
      maps["<Leader>jr"] = { "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate Cell" }
      maps["<Leader>jo"] = { "<cmd>MoltenShowOutput<cr>", desc = "Show Output" }
      maps["<Leader>jh"] = { "<cmd>MoltenHideOutput<cr>", desc = "Hide Output" }
      maps["<Leader>jc"] = { "<cmd>MoltenDelete<cr>", desc = "Delete Cell Output" }
      maps["<Leader>js"] = { "<cmd>MoltenExportOutput<cr>", desc = "Save to Notebook (.ipynb)" }
      maps["<Leader>jt"] = { "<cmd>!jupytext --to ipynb %<cr>", desc = "Jupytext: Convert to .ipynb" }
      
      -- Visual mode mapping for execution
      if not opts.mappings.v then opts.mappings.v = {} end
      opts.mappings.v["<Leader>je"] = { ":<C-u>MoltenEvaluateVisual<cr>gv", desc = "Execute Visual" }
    end,
  },
}