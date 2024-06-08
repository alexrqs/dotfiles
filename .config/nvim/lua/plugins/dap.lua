local js_languages = {
  "javascript",
  "typescript",
  "typescriptreact",
  "javascriptreact",
}

return {
  {

    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      local Config = require("lazyvim.config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      for _, language in ipairs(js_languages) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "l&d Node",
            program = "${workspaceFolder}/${file}",
            skipFiles = { "<node_internals>/**/*.js" },
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "attach to Node",
            port = 9229,
            skipFiles = { "<node_internals>/**/*.js" },
            sourceMaps = true,
            cwd = "${workspaceFolder}",
            processId = require("dap.utils").pick_process,
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "l&d Chrome",
            url = function()
              local co = coroutine.running()

              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = "${workspace}",
            skipFiles = { "<node_internals>/**/*.js" },
            protocol = "inspector",
            sourceMaps = true,
            useDataDir = false,
          },
        }
      end
    end,
    keys = {
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step out",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step over",
      },
      {
        "<leader>da",
        function()
          if vim.fn.filereadable("./vscode/launch.json") then
            local dap_vscode = require("dap.ext.vscode")
            dap_vscode.load_launchjs(nil, {
              ["pwa-node"] = js_languages,
              ["pwa-chrome"] = js_languages,
              ["node"] = js_languages,
              ["chrome"] = js_languages,
            })
          end
          require("dap").continue()
        end,
        desc = "Run with args",
      },
    },

    dependencies = {
      {
        "microsoft/vscode-js-debug",
        build = "bun install --legacy-peer-deps && bunx gulp vsDebugServerBundle && mv dist out",
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        config = function()
          require("dap-vscode-js").setup({
            -- the path to the vscode-js-debug extension
            -- ~/.local/share/nvim is the directory from vim.fn.stdpath("data")
            debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

            adapters = {
              "pwa-node",
              "pwa-chrome",
              "pwa-msedge",
              "pwa-extensionHost",
              "node-terminal",
              "chrome",
              "node",
            },
          })
        end,
      },
      {
        "Joakker/lua-json5",
        build = "./install.sh",
      },
    },
  },
}
