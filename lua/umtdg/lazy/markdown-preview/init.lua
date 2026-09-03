---@type LazyPluginSpec
return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown' },

  build = function()
    vim.fn['mkdp#util#install']()
  end,

  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }

    -- default markdown-preview CSS
    local plugin_css_path = vim.fn.stdpath 'data' .. '/lazy/markdown-preview.nvim/app/_static/markdown.css'
    local plugin_css_input = assert(io.open(plugin_css_path, 'r'))
    local plugin_css = plugin_css_input:read '*a'
    plugin_css_input:close()

    -- override CSS
    local override_css_path = vim.fn.stdpath 'config' .. '/lua/umtdg/lazy/markdown-preview/markdown.css'
    local override_css_input = assert(io.open(override_css_path, 'r'))
    local override_css = override_css_input:read '*a'
    override_css_input:close()

    -- combine plugin's own CSS with custom overrides
    local generated_css_path = vim.fn.stdpath 'cache' .. '/markdown-preview.css'
    local generated_css_output = assert(io.open(generated_css_path, 'w'))
    generated_css_output:write(plugin_css)
    generated_css_output:write '\n\n/* Custom overrides */\n'
    generated_css_output:write(override_css)
    generated_css_output:close()

    vim.g.mkdp_markdown_css = generated_css_path
  end,
}
