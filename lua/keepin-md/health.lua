local M = {}

function M.check()
  local health = vim.health or require("health")

  health.report_start("Markdown Formatter")

  -- Check Neovim version
  if vim.fn.has('nvim-0.7.0') == 1 then
    health.report_ok("Neovim version >= 0.7.0")
  else
    health.report_error("Neovim version must be >= 0.7.0")
  end

  -- Check if required Neovim features are available
  if vim.api.nvim_create_autocmd then
    health.report_ok("Required Neovim API functions are available")
  else
    health.report_error("Required Neovim API functions are not available")
  end
end

return M
