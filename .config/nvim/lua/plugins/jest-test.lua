-- Directories that mirror the source tree in their output (coverage reports,
-- build artifacts, git worktrees checked out under a dot-dir). neotest-jest's
-- file matcher returns true for *any* path containing `__tests__`, without
-- checking the extension, so `coverage/lcov-report/api/__tests__/api.test.js.html`
-- gets discovered as a test file and jest is spawned on it.
local IGNORED_DIRS = {
  ["node_modules"] = true,
  ["coverage"] = true,
  ["dist"] = true,
  ["build"] = true,
  [".next"] = true,
}

-- `jest_test_discovery` only enriches positions flagged `is_parameterized`, which
-- neotest-jest sets for `.each` and for non-string name nodes. A template-literal
-- name (`it(`parsing ${type} ...`)`) takes the `template_string` branch instead, so
-- it stays unflagged: treesitter records one position whose name still holds the
-- `${...}`, jest reports the interpolated names, nothing matches, and the file ends
-- up with no results. Flag those too so jest discovery fills in the real children.
local template_literal_discovery_enabled = false

local function enable_template_literal_discovery()
  if template_literal_discovery_enabled then
    return
  end
  template_literal_discovery_enabled = true

  local adapter = require("neotest-jest")
  local build_position = adapter.build_position

  adapter.build_position = function(...)
    local pos = build_position(...)
    if pos and pos.name and pos.name:find("${", 1, true) then
      pos.is_parameterized = true
    end
    return pos
  end
end

-- LazyVim's test keymaps pass `vim.fn.expand("%")`, which is the *buffer name* —
-- from neo-tree or the Neotest summary that is "neo-tree filesystem 1" or
-- "Neotest Summary", and neotest errors with `No position found with args`.
-- Walk the window list for the most recent real file instead.
local function current_file()
  local function is_file(buf)
    return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
  end

  if is_file(0) then
    return vim.fn.expand("%:p")
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if is_file(buf) then
      return vim.api.nvim_buf_get_name(buf)
    end
  end
end

-- `output.open_on_run` only fires when a test *fails* and the cursor is inside
-- that test's range, so a full-suite run shows nothing. Open the summary on every
-- run instead, and let the results listener below surface failures.
local function run_and_show(args)
  local neotest = require("neotest")
  neotest.summary.open()
  neotest.run.run(args)
end

-- Discovery is async, so right after startup the position tree is still empty:
-- `run.run(cwd)` finds no position ("No tests found") and `run.run({suite=true})`
-- asserts inside `_get_adapter`, because `get_adapters()` only returns adapters
-- whose root already has children. Wait for an adapter to register, then run.
local function run_suite(attempt)
  local neotest = require("neotest")
  attempt = attempt or 1

  if attempt == 1 then
    neotest.summary.open()
  end

  if #neotest.state.adapter_ids() > 0 then
    return neotest.run.run({ suite = true })
  end

  if attempt > 60 then
    return vim.notify("Timed out waiting for test discovery", vim.log.levels.WARN, { title = "Neotest" })
  end

  vim.defer_fn(function()
    run_suite(attempt + 1)
  end, 500)
end

--- Run `fn` with the current file, or warn if there isn't one.
local function with_file(fn)
  return function()
    local file = current_file()
    if not file then
      return vim.notify("No test file in this tab", vim.log.levels.WARN, { title = "Neotest" })
    end
    fn(file)
  end
end

return {
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/neotest-jest", "marilari88/neotest-vitest" },
    -- stylua: ignore
    keys = {
      { "<leader>tt", with_file(function(f) run_and_show(f) end), desc = "Run File (Neotest)" },
      { "<leader>tT", function() run_suite() end, desc = "Run All Test Files (Neotest)" },
      { "<leader>tr", function() run_and_show() end, desc = "Run Nearest (Neotest)" },
      { "<leader>tw", with_file(function(f) require("neotest").watch.toggle(f) end), desc = "Toggle Watch (Neotest)" },
    },
    -- Adapters are resolved by LazyVim's `test.core` extra (see lazyvim.json),
    -- which turns these names + configs into adapter instances.
    opts = {
      discovery = {
        filter_dir = function(name)
          -- Skip dot-directories: git worktrees live under one and are full
          -- repo copies, so discovering them collects every suite twice.
          return not IGNORED_DIRS[name] and not name:match("^%.")
        end,
      },
      -- Auto-open the output panel when a run produces failures, regardless of
      -- where the cursor is (`output.open_on_run` is cursor-scoped).
      consumers = {
        auto_output = function(client)
          client.listeners.results = function(_, results, partial)
            if partial then
              return
            end
            for _, result in pairs(results) do
              if result.status == "failed" then
                vim.schedule(function()
                  require("neotest").output_panel.open()
                end)
                return
              end
            end
          end
        end,
      },
      adapters = {
        ["neotest-jest"] = {
          env = { CI = true },
          -- Tests generated at runtime (`for (const k in x) describe(k, ...)`,
          -- `.each`, template-literal names) are invisible to treesitter, so the
          -- file yields no positions and neotest propagates a non-passed status up
          -- to every parent directory. This runs jest once per such file with a
          -- never-matching `-t` pattern to list the real test names.
          jest_test_discovery = true,
          isTestFile = function(path)
            -- `test.core` requires the adapter before applying this config, so the
            -- module is loaded by now and wrapping here keeps it lazy. Idempotent.
            enable_template_literal_discovery()
            -- Delegate to the adapter's own matcher (it also checks for a jest
            -- dependency), but require a real JS/TS extension first: its
            -- `__tests__` branch short-circuits before checking the extension, so
            -- `__snapshots__/x.test.js.snap` would otherwise match.
            return path ~= nil
              and path:match("%.[jt]sx?$") ~= nil
              and require("neotest-jest.jest-util").defaultIsTestFile(path)
          end,
        },
        ["neotest-vitest"] = {},
      },
    },
  },
}
