local M = {}

--- Checks if the current buffer is modified.
--
-- Returns:
-- bool: True if the buffer is modified, False otherwise.
--
local function is_buffer_modified()
  local buf = vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_option(buf, "modified")
end

--- Switch to an existing buffer in Neovim.
--
-- This function checks if a buffer is already open in a window. If it is, it
-- switches to that window. If it is not, it switches to the existing buffer.
--
-- @param new_window (boolean) Whether to open the buffer in a new window. If
--   true, the buffer will be opened in a new split window. If false, the buffer
--   will be opened in the current window.
-- @param buffer_num (number) The buffer number of the buffer.
--
-- @return None
--
local function switch_to_existing_buffer(new_window, buffer_num)
  -- Check if the buffer number is valid
  if type(buffer_num) ~= "number" or buffer_num < 1 then
    error("Invalid buffer number provided to switch_to_existing_buffer")
    return
  end

  -- See if this buffer is already open in a window
  local window_num = vim.fn.bufwinnr(buffer_num)

  if window_num ~= -1 then
    -- Switch to that window (even if we're already there)
    vim.cmd(window_num .. " wincmd w")
  else
    -- Switch to the existing scratch buffer
    local cmd = new_window and "split +buffer " or "buffer "
    vim.cmd(cmd .. buffer_num)
  end
end

--- Creates a new scratch buffer in Neovim.
--
-- This function creates a new scratch buffer in Neovim, either in a new window
-- or by editing the current buffer. The buffer is configured to work like a
-- scratch buffer, meaning it is not backed by a file and has specific options
-- set.
--
-- @param new_window (boolean) Whether to create the scratch buffer in a new
--   window. If true, the buffer will be created in a new window. If false, the
--   buffer will be created by editing the current buffer.
-- @param buffer_name (string) The name of the buffer.
--
-- @return None
--
local function create_new_scratch_buffer(new_window, buffer_name)
  -- Check if the buffer name is set
  if not buffer_name or type(buffer_name) ~= "string" then
    error("Buffer name not set or invalid in create_new_scratch_buffer")
    return
  end

  -- Either new (for split) or edit the new buffer with buffer_name
  local cmd = new_window and "new " or "edit "
  vim.cmd(cmd .. buffer_name)

  -- Sets the options for the buffer to work like a scratch buffer.
  local buf = vim.api.nvim_get_current_buf() -- should always be 0
  vim.api.nvim_buf_set_option(buf, "bufhidden", "hide") -- what to do when the buffer is hidden
  vim.api.nvim_buf_set_option(buf, "buflisted", true) -- include the buffer in the :bnext list
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile") -- nofile means the buffer isn't backed by a file and we control its name
  vim.api.nvim_buf_set_option(buf, "swapfile", false) -- never swapfiles
end

--- Opens or splits a window based on the specified conditions.
--
-- This function checks if a new window needs to be opened or if it should
-- switch to an existing buffer. It first determines if a new window is
-- required based on the input parameter or if the current buffer is modified.
-- Then, it searches for an existing scratch buffer. If found, it switches to
-- that buffer. Otherwise, it creates a new scratch buffer.
--
-- @param new_window A boolean indicating whether a new window should be created. If not provided,
--                   it defaults to the state of the buffer's modification (true if modified).
--
-- @return None
--
local function open_or_split(new_window)
  -- Create new window if requested or if buffer is modified
  new_window = new_window or is_buffer_modified()

  -- Look for an existing scratch buffer
  local scratch_buffer_num = vim.fn.bufnr(M.config.buffer_name)
  if scratch_buffer_num ~= -1 then
    -- Found it, switch to it
    switch_to_existing_buffer(new_window, scratch_buffer_num)
  else
    -- Didn't find it, create one
    create_new_scratch_buffer(new_window, M.config.buffer_name)
  end
end

--- Splits the current window and opens or switches to the scratch buffer.
--
-- This function is designed to be a public interface for opening or switching
-- to the scratch buffer in a new split window. It internally calls the
-- `open_or_split` function with `true` to indicate the need for a split window.
--
-- Usage:
-- :lua require('scratch').split()
--
function M.split()
  open_or_split(true)
end

--- Opens or switches to the scratch buffer in the current window.
--
-- This function is a public interface for opening or switching to the scratch
-- buffer in the current window without splitting. It calls the `open_or_split`
-- function with `false`, indicating no new window is needed.
--
-- Usage:
-- :lua require('scratch').open()
--
function M.open()
  open_or_split(false)
end

--- Sets up the scratch buffer plugin with optional configuration.
--
-- This function initializes the scratch buffer plugin and binds Neovim
-- commands to the plugin's functionalities. It also allows for optional
-- configuration through the `opts` parameter.
--
-- @param opts (table) Optional configuration table. It can contain a key
--   `buffer_name` to specify the name of the scratch buffer. If not provided,
--   defaults to "_SCRATCH_". An error is raised if `buffer_name` is provided but
--   is not a string.
--
-- Usage:
-- :lua require('scratch').setup({ buffer_name = "my_scratch" })
--
function M.setup(opts)
  -- Default configuration
  M.config = {
    buffer_name = "_SCRATCH_",
  }

  -- Check for configuration overrides passed in via opts
  if opts ~= nil and type(opts) == "table" then
    if opts.buffer_name and type(opts.buffer_name) ~= "string" then
      error("Invalid buffer name provided in setup options")
      return
    end
    M.config.buffer_name = opts.buffer_name or M.config.buffer_name
  end

  -- Bind commands to our lua functions
  vim.api.nvim_create_user_command("Scratch", M.open, {})
  vim.api.nvim_create_user_command("ScratchSplit", M.split, {})
end

return M
