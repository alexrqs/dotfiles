return {
    "folke/snacks.nvim",
    opts = {
        image = { enabled = true },
    },
    init = function()
        -- FIX: image blank after leaving and returning to its buffer (snacks #2896, PR #2964)
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            once = true,
            callback = function()
                local placement = require("snacks.image.placement")
                local update = placement.update
                placement.update = function(self, ...)
                    if self.hidden and #self:wins() > 0 then
                        self.hidden = false
                        self._state = nil
                    end
                    return update(self, ...)
                end

                -- FIX: progress()/error() rewrite buffer lines without clearing 'modified'
                for _, name in ipairs({ "progress", "error" }) do
                    local fn = placement[name]
                    placement[name] = function(self, ...)
                        fn(self, ...)
                        if vim.api.nvim_buf_is_valid(self.buf) then
                            vim.bo[self.buf].modified = false
                        end
                    end
                end
            end,
        })
    end,
}
