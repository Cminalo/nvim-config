# AstroNvim Data Science & Pixi Workflow

This Neovim configuration is deeply integrated with **Pixi** for environment management and **Molten/image.nvim** for a rich, inline Jupyter Notebook experience. This document outlines how to use the custom tooling.

## 📦 Pixi Environment Management

Instead of relying on global Python installations, this setup detects and hooks into your `pixi` environments, updating your LSP (Pyright), DAP (Debugger), and Terminal instances on the fly.

### Keybindings (Leader `v`)
- `<Leader>ve` : **Select Environment**. Opens a picker listing all environments in your `pixi.toml`. Selecting one will:
  1. Prepend the `.pixi/envs/<name>/bin` to your `PATH`.
  2. Set `VIRTUAL_ENV`.
  3. Update `nvim-dap-python` to use the correct executable.
  4. Automatically restart the Python LSP so imports resolve correctly.
- `<Leader>vr` : **Run Task**. Lists all tasks available for the *currently selected* environment and runs the chosen task in a terminal split.
- `<Leader>vc` : **Open Console**. Opens a standard Neovim terminal split and starts a Python REPL using the selected environment.
- `<Leader>vd` : **Debug**. Directly launches or continues the DAP debugger using the selected environment's Python.

*(Note: If a `default` environment exists when Neovim opens, it will automatically be loaded without needing to press `<Leader>ve`.)*

---

## 📓 Jupyter Notebook Workflow

This setup allows you to treat standard `.py` files (using `# %%` markers) as full Jupyter Notebooks. The code is executed via the `ipykernel` in your Pixi environment, but the UI is handled by Neovim.

**Prerequisites for a new project:**
To run code in a Pixi project, the project must have `ipykernel` installed, and the kernel must be registered:
```bash
pixi add ipykernel
pixi run python -m ipykernel install --user --name my-project-name
```

### Keybindings (Leader `j`)
- `<Leader>ji` : **Initialize Molten**. Run this once per session. It will ask you to select a kernel. Choose the one matching your project.
- `<Leader>je` : **Evaluate Operator**. Runs a block of code.
  - *For a block without empty lines:* Place cursor inside the block, press `<Leader>je`, then `ip` (inner paragraph).
  - *For multi-line blocks:* Press `V` to highlight the lines, then press `<Leader>je`.
- `<Leader>jl` : **Evaluate Line**. Runs only the current line your cursor is on.
- `<Leader>jr` : **Re-evaluate**. Re-runs the last cell you evaluated.
- `<Leader>jo` / `<Leader>jh` : **Show / Hide Output**. Toggles a floating window containing the full output text (useful for large dataframes or tracebacks).
- `<Leader>jc` : **Clear Cell**. Deletes the output associated with the current cell.

### 🖼️ Inline Images (Matplotlib)
If you run a cell containing a plot (e.g., `plt.show()`), the image will render directly inside your WezTerm terminal buffer below the code.
- WezTerm must be configured to use the `WebGpu` front-end to prevent graphical tearing when scrolling.
- Images will automatically clear when you enter `Insert` mode to prevent text overlap, and will reappear when you return to `Normal` mode.

### 💾 Saving & Exporting to `.ipynb`
Working in standard `.py` files is great for Git and your LSP, but sometimes you need an actual `.ipynb` file to share.
- `<Leader>js` : **Molten Export**. Saves your current Python script *and all currently generated outputs/images* into a new `.ipynb` file.
- `<Leader>jt` : **Jupytext Convert**. Instantly converts your current `.py` script into a clean `.ipynb` file (without outputs).

---

## ⚙️ Architecture: Host vs. Execution
- **Host Layer:** Neovim uses your system Homebrew Python (`/opt/homebrew/bin/python3`) via `g:python3_host_prog` to run the UI, process images (`imagemagick` / `cairosvg`), and manage the Neovim-to-Jupyter bridge.
- **Execution Layer:** Your code is executed exclusively inside the isolated `pixi` environment you select, keeping dependencies clean and project-specific.
