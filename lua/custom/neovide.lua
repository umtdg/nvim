local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

local increase_scale_factor = function ()
  -- +25%
  change_scale_factor(1.25)
end

local decrease_scale_factor = function ()
  -- -25%
  change_scale_factor(1 / 1.25)
end

-- Options
vim.o.guifont = 'MesloLGS NF:h12'

decrease_scale_factor()

vim.g.neovide_hide_mouse_when_typing = true

vim.g.neovide_cursor_animation_length = 0.04
vim.g.neovide_cursor_short_animation_length = 0.04
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = false

-- Keymaps
vim.keymap.set('n', '<C-=>', function()
  increase_scale_factor()
end, { desc = 'Neovide: Increase scaling' })

vim.keymap.set('n', '<C-->', function()
  decrease_scale_factor()
end, { desc = 'Neovide: Decrease scaling' })
