--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local function check_version()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.ge(vim.version(), '0.12') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

--- Normalize given array so that:
---   string[] -> string[]
---   string -> string[]
--- @param tbl (string | string[])[]
local function tbl_normalize(tbl)
  local normalized = {}
  for _, item in ipairs(tbl) do
    if type(item) == 'string' then
      table.insert(normalized, { item })
    elseif type(item) == 'table' then
      table.insert(normalized, item)
    end
  end

  return normalized
end

--- Check if any of the given executables is available
--- @param executables string[]
--- @return boolean
local function is_any_executable(executables)
  for _, exe in ipairs(executables) do
    if vim.fn.executable(exe) == 1 then
      return true
    end
  end

  return false
end

local function check_external_reqs()
  -- Basic utils: `git`, `make`, `unzip`
  -- Mason: `curl` or `wget`, `tar` or `gtar`
  local required = { 'git', 'make', 'unzip', 'rg', { 'curl', 'wget' }, { 'tar', 'gtar' } }
  for _, exes in ipairs(tbl_normalize(required)) do
    local exes_str = table.concat(exes, ' or ')
    if is_any_executable(exes) then
      vim.health.ok(string.format("Found executable: '%s'", exes_str))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exes_str))
    end
  end
end

local function check_lsp_reqs()
  -- These are the ones that have `use_mason = false` under `lua/umtdg/lazy/lsp.lua`
  local required = { 'clangd', 'pyright', 'nil' }
  for _, exes in ipairs(tbl_normalize(required)) do
    local exes_str = table.concat(exes, ' or ')
    if is_any_executable(exes) then
      vim.health.ok(string.format("Found LSP: '%s'", exes_str))
    else
      vim.health.warn(string.format("Could not find LSP: '%s'", exes_str))
    end
  end
end

local function check()
  vim.health.start 'umtdg.nvim'

  local uv = vim.uv or vim.loop
  vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

  check_version()
  check_external_reqs()
  check_lsp_reqs()
end

return {
  check = check,
}
