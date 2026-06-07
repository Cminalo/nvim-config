-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = "astrodark",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = { -- this table overrides highlights in all themes
        Normal = { bg = "NONE", ctermbg = "NONE" },
        NormalNC = { bg = "NONE", ctermbg = "NONE" },
        CursorLine = { bg = "NONE", ctermbg = "NONE" },
        SignColumn = { bg = "NONE", ctermbg = "NONE" },
        StatusLine = { bg = "NONE", ctermbg = "NONE" },
        StatusLineNC = { bg = "NONE", ctermbg = "NONE" },
        EndOfBuffer = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeNormal = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeNormalNC = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeWinSeparator = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeEndOfBuffer = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabActive = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabInactive = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabSeparator = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabArea = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeSourceSelectorTabActive = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeSourceSelectorTabInactive = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeSourceSelectorSeparator = { bg = "NONE", ctermbg = "NONE" },
        WinSeparator = { bg = "NONE", ctermbg = "NONE" },
        VertSplit = { bg = "NONE", ctermbg = "NONE" },
        TabLine = { bg = "NONE", ctermbg = "NONE" },
        TabLineFill = { bg = "NONE", ctermbg = "NONE" },
        TabLineSel = { bg = "NONE", ctermbg = "NONE" },
        NormalFloat = { bg = "NONE", ctermbg = "NONE" },
        FloatBorder = { bg = "NONE", ctermbg = "NONE" },
        WinBar = { bg = "NONE", ctermbg = "NONE" },
        WinBarNC = { bg = "NONE", ctermbg = "NONE" },
        Pmenu = { bg = "NONE", ctermbg = "NONE" },
        PmenuSel = { bg = "NONE", ctermbg = "NONE" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
