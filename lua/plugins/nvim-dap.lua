return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- UI plugins to make debugging simpler
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "tpope/vim-dotenv", -- Add this plugin to load .env files in Lua
  },
  config = function()
    -- Source the .env file using vim-dotenv
    vim.cmd [[Dotenv ~/.config/nvim-dot-env/services/.env]]

    -- gain access to the dap plugin and its functions
    local dap = require "dap"
    -- gain access to the dap ui plugin and its functions
    local dapui = require "dapui"

    -- Setup the dap ui with default configuration
    dapui.setup()

    -- setup an event listener for when the debugger is launched
    dap.listeners.before.launch.dapui_config = function()
      -- when the debugger is launched open up the debug ui
      dapui.open()
    end

    -- set a vim motion for <Space> + d + t to toggle a breakpoint at the line where the cursor is currently on
    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "[D]ebug [T]oggle Breakpoint" })

    -- set a vim motion for <Space> + d + s to start the debugger and launch the debugging ui
    vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "[D]ebug [S]tart" })

    -- set a vim motion to close the debugging ui
    vim.keymap.set("n", "<leader>dc", dapui.close, { desc = "[D]ebug [C]lose" })

    -- Add Java debugging configurations dynamically from .env
    local services = {
      { name = "SERVICE_1" },
      { name = "SERVICE_2" },
      { name = "SERVICE_3" },
      { name = "SERVICE_4" },
      { name = "SERVICE_5" },
      { name = "SERVICE_6" },
      { name = "SERVICE_7" },
    }

    dap.configurations.java = {}

    for _, service in ipairs(services) do
      local name = service.name
      local configuration = {
        type = "java",
        name = "Debug " .. os.getenv(name .. "_NAME") .. " (Attach)",
        projectName = os.getenv(name .. "_PROJECT"),
        request = "attach",
        hostName = os.getenv(name .. "_HOST"),
        port = tonumber(os.getenv(name .. "_PORT")),
        stepFilters = {
          skipClasses = {
            "$JDK",
            "junit.*",
            "io.quarkus.*",
            "io.vertx.*",
            "com.arjuna.*",
          },
          skipSynthetics = false,
          skipStaticInitializers = false,
          skipConstructors = false,
        },
      }
      table.insert(dap.configurations.java, configuration)
    end
  end,
}
