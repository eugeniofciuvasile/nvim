return {
  -- Optionally add the Angular language server plugin as a dependency (for Mason or lazy loading)
  {
    "AstroNvim/astrolsp",
    opts = {
      setup_handlers = {
        -- Custom handler for Angular LSP
        angularls = function(_, opts)
          -- Utility for finding project root
          local util = require "lspconfig.util"

          -- Probe for node_modules directory to use the project's local Angular/TypeScript
          local function get_probe_dir(root_dir)
            local found = vim.fs.find("node_modules", { path = root_dir, upward = true })
            local project_root = found and found[1] and vim.fs.dirname(found[1]) or nil
            return project_root and (project_root .. "/node_modules") or ""
          end

          -- Get the @angular/core version from package.json if available
          local function get_angular_core_version(root_dir)
            local found = vim.fs.find("node_modules", { path = root_dir, upward = true })
            local project_root = found and found[1] and vim.fs.dirname(found[1]) or nil
            if not project_root then return "" end
            local package_json = project_root .. "/package.json"
            if not vim.uv.fs_stat(package_json) then return "" end
            local file = io.open(package_json, "r")
            if not file then return "" end
            local contents = file:read "*a"
            file:close()
            local ok, json = pcall(vim.json.decode, contents)
            if not ok or not json or not json.dependencies then return "" end
            local angular_core_version = json.dependencies["@angular/core"]
            angular_core_version = angular_core_version and angular_core_version:match "%d+%.%d+%.%d+"
            return angular_core_version or ""
          end

          local default_probe_dir = get_probe_dir(vim.fn.getcwd())
          local default_angular_core_version = get_angular_core_version(vim.fn.getcwd())

          -- Compose the Angular LSP config, preferring the project's local node_modules
          opts.cmd = {
            "ngserver",
            "--stdio",
            "--tsProbeLocations",
            default_probe_dir,
            "--ngProbeLocations",
            default_probe_dir,
            "--angularCoreVersion",
            default_angular_core_version,
          }
          opts.filetypes = {
            "typescript",
            "html",
            "typescriptreact",
            "typescript.tsx",
            "htmlangular",
          }
          -- Use angular.json as the root marker (works for monorepos)
          opts.root_dir = util.root_pattern "angular.json"
          opts.on_new_config = function(new_config, new_root_dir)
            local new_probe_dir = get_probe_dir(new_root_dir)
            local angular_core_version = get_angular_core_version(new_root_dir)
            new_config.cmd = {
              vim.fn.exepath "ngserver",
              "--stdio",
              "--tsProbeLocations",
              new_probe_dir,
              "--ngProbeLocations",
              new_probe_dir,
              "--angularCoreVersion",
              angular_core_version,
            }
          end
          require("lspconfig").angularls.setup(opts)
        end,
      },
    },
  },
  {
    -- Optionally, ensure Angular language server is installed via Mason for convenience
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = { "angular-language-server" },
    },
  },
}
