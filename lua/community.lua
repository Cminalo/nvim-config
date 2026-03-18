-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.python" },
  -- The "Pack" includes the LSP and basic settings
  { import = "astrocommunity.pack.markdown" },
  -- This is the specific plugin for the "pretty" UI
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  -- import/override with your plugins folder
}
