---@class ProjectConformConfig: conform.setupOpts
---@field lsp_format? conform.LspFormatOpts
---
---@class ProjectLintConfig
---@field linters_by_ft? table<string, string[]>
---@field linters? table<string, lint.Linter|fun():lint.Linter>
---
---@class ProjectConfig
---@field name? string
---@field lsp? table<string, LspConfig>
---@field conform? ProjectConformConfig
---@field lint? ProjectLintConfig
---@field jdtls? vim.lsp.ClientConfig
---@field rustaceanvim? rustaceanvim.Opts

local profiles = {
  ['/mnt/ssd500/btrfs/work/ran/ran'] = 'ulak-ran',
}

local name = profiles[vim.fn.getcwd()]
local profile = name and require('umtdg.projects.' .. name) or {}
assert(type(profile) == 'table', 'Project profile must return a table')
profile.name = profile.name or name or 'default'

-- This module is required at startup; require caches the selection for the instance.
return {
  get = function()
    return profile
  end,
}
