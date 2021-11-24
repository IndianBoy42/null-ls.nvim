local stub = require("luassert.stub")

local config = require("null-ls.config")
local handlers = require("null-ls.handlers")
local rpc = require("null-ls.rpc")
local lspconfig = require("null-ls.lspconfig")

describe("init", function()
    local null_ls = require("null-ls")

    it("should expose methods and variables", function()
        assert.equals(type(null_ls.register), "function")
        assert.equals(type(null_ls.is_registered), "function")
        assert.equals(type(null_ls.register_name), "function")
        assert.equals(type(null_ls.methods), "table")
        assert.equals(type(null_ls.builtins), "table")
        assert.equals(type(null_ls.null_ls_info), "function")
        assert.equals(type(null_ls.generator), "function")
        assert.equals(type(null_ls.formatter), "function")
    end)

    describe("config", function()
        before_each(function()
            stub(config, "setup")
            stub(rpc, "setup")
            stub(lspconfig, "setup")
            stub(handlers, "setup")
        end)

        after_each(function()
            config.setup:revert()
            rpc.setup:revert()
            lspconfig.setup:revert()
            handlers.setup:revert()

            config.reset()
            vim.g.null_ls_disable = nil
            vim.cmd("silent! delcommand NullLsInfo")
        end)

        it("should not set up null-ls if null_ls_disable is set", function()
            vim.g.null_ls_disable = true

            null_ls.config()

            assert.stub(config.setup).was_not_called()
        end)

        it("should not set up null-ls if already set up", function()
            config._set({ _setup = true })

            null_ls.config()

            assert.stub(config.setup).was_not_called()
        end)

        it("should set up null-ls with empty config", function()
            null_ls.config()

            assert.stub(config.setup).was_called()
            assert.stub(rpc.setup).was_called()
            assert.stub(lspconfig.setup).was_called()
            assert.stub(handlers.setup).was_called()

            assert.equals(vim.fn.exists(":NullLsInfo") > 0, true)
            assert.equals(vim.fn.exists(":NullLsLog") > 0, true)
            assert.truthy(vim.fn.exists("#NullLs#FileType") > 0)
            assert.truthy(vim.fn.exists("#NullLs#InsertLeave") > 0)
        end)

        it("should set up null-ls with user config", function()
            local user_config = { my_config_key = "val" }

            null_ls.config(user_config)

            assert.stub(config.setup).was_called_with(user_config)
        end)
    end)
end)
