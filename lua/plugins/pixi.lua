-- A custom plugin to integrate `pixi` with AstroNvim
-- It adds a `<Leader>v` menu for Pixi task runner, environment selection, and REPL
return {
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      if not opts.mappings then opts.mappings = {} end
      if not opts.mappings.n then opts.mappings.n = {} end
      local maps = opts.mappings.n

      -- Define Which-key group
      maps["<Leader>v"] = { desc = " Pixi" }

      -- Helper to run pixi commands and parse json
      local function run_pixi_json(args, callback)
        vim.system(args, { text = true }, function(out)
          if out.code == 0 then
            local success, json = pcall(vim.json.decode, out.stdout)
            if success then
              callback(json)
            else
              vim.schedule(function() vim.notify("Failed to parse pixi JSON output", vim.log.levels.ERROR) end)
            end
          else
            vim.schedule(function() vim.notify("Pixi command failed: " .. out.stderr, vim.log.levels.ERROR) end)
          end
        end)
      end

      -- Update Environment State
      local function set_pixi_env(env_name)
        vim.g.pixi_active_env = env_name
        local env_path = vim.fn.getcwd() .. "/.pixi/envs/" .. env_name
        local python_path = env_path .. "/bin/python"

        -- 1. Set VIRTUAL_ENV for LSPs like Pyright to pick up
        vim.env.VIRTUAL_ENV = env_path
        
        -- 2. Update PATH so that terminals, DAP, and other tools default to this env's python
        if not vim.g.original_path then
          vim.g.original_path = vim.env.PATH
        end
        vim.env.PATH = env_path .. "/bin:" .. vim.g.original_path

        -- 3. Update dap-python and DAP adapters if available
        local dap_python_ok, dap_python = pcall(require, "dap-python")
        if dap_python_ok then
          dap_python.resolve_python = function() return python_path end
        end
        local dap_ok, dap = pcall(require, "dap")
        if dap_ok and dap.adapters.python then
          if type(dap.adapters.python) == "table" then
            dap.adapters.python.command = python_path
          end
        end

        -- 4. Dynamically update LSP clients and restart them
        local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = 0 }) or vim.lsp.get_active_clients({ bufnr = 0 })
        local restarted = false
        for _, client in ipairs(clients) do
          if client.name == "pyright" or client.name == "basedpyright" then
            client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
              python = {
                pythonPath = python_path
              }
            })
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            vim.cmd("LspRestart " .. client.name)
            restarted = true
          elseif client.name == "pylsp" then
            vim.cmd("LspRestart " .. client.name)
            restarted = true
          end
        end

        vim.notify("Pixi env set to: " .. env_name .. (restarted and " (LSP restarted)" or ""), vim.log.levels.INFO)
      end

      -- `<Leader>ve` Select Environment
      maps["<Leader>ve"] = {
        function()
          run_pixi_json({"pixi", "info", "--json"}, function(info)
            local envs = info.environments_info or {}
            local items = {}
            for _, env in ipairs(envs) do
              table.insert(items, env.name)
            end
            if #items == 0 then
              vim.schedule(function() vim.notify("No pixi environments found.", vim.log.levels.WARN) end)
              return
            end
            
            vim.schedule(function()
              vim.ui.select(items, {
                prompt = "Select Pixi Environment",
              }, function(choice)
                if choice then
                  set_pixi_env(choice)
                end
              end)
            end)
          end)
        end,
        desc = "Select Environment",
      }

      -- `<Leader>vr` Run Task
      maps["<Leader>vr"] = {
        function()
          local env = vim.g.pixi_active_env or "default"
          -- Some older pixi versions don't support --json on task list, try it, fallback if it fails
          run_pixi_json({"pixi", "task", "list", "-e", env, "--json"}, function(json)
            local tasks = json.tasks or json or {}
            local items = {}
            for _, task in ipairs(tasks) do
              if task.name then
                table.insert(items, task.name)
              end
            end
            if #items == 0 then
              vim.schedule(function() vim.notify("No pixi tasks found for env: " .. env, vim.log.levels.WARN) end)
              return
            end

            vim.schedule(function()
              vim.ui.select(items, {
                prompt = "Select Pixi Task (" .. env .. ")",
              }, function(choice)
                if choice then
                  local cmd = "pixi run -e " .. env .. " " .. choice
                  vim.cmd("split | terminal " .. cmd)
                  vim.cmd("startinsert")
                end
              end)
            end)
          end)
        end,
        desc = "Run Task",
      }

      -- `<Leader>vc` Open Console
      maps["<Leader>vc"] = {
        function()
          local env = vim.g.pixi_active_env or "default"
          local cmd = "pixi run -e " .. env .. " python"
          vim.cmd("split | terminal " .. cmd)
          vim.cmd("startinsert")
        end,
        desc = "Open Python Console",
      }

      -- `<Leader>vd` Debug with DAP
      maps["<Leader>vd"] = {
        function()
          local dap_ok, dap = pcall(require, "dap")
          if not dap_ok then
            vim.notify("nvim-dap is not installed", vim.log.levels.ERROR)
            return
          end
          local env = vim.g.pixi_active_env
          if not env then
            set_pixi_env("default")
            env = "default"
          end
          
          -- AstroNvim uses <Leader>d for debugging menu. This provides direct execution.
          dap.continue()
        end,
        desc = "Start/Continue Debugger (Pixi Env)",
      }

      -- Init logic (runs when plugin loads)
      vim.schedule(function()
        if not vim.g.pixi_active_env and vim.fn.isdirectory(vim.fn.getcwd() .. "/.pixi/envs/default") == 1 then
          vim.g.pixi_active_env = "default"
          local env_path = vim.fn.getcwd() .. "/.pixi/envs/default"
          vim.env.VIRTUAL_ENV = env_path
          if not vim.g.original_path then
            vim.g.original_path = vim.env.PATH
          end
          vim.env.PATH = env_path .. "/bin:" .. vim.g.original_path
          
          -- Note: We don't restart LSP here automatically to avoid a double-start on launch,
          -- as VIRTUAL_ENV and PATH are already set before LSP fully initializes.
        end
      end)
    end,
  }
}