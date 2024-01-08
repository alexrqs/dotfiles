local js_languages = {
  "javascript",
  "typescript",
  "typescriptreact",
  "javascriptreact",
}

return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")

    local conig = require("lazyvim.config")
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
          type = "pwa-chrome",
          request = "launch",
          name = "launch & debug Chrome",
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
}
