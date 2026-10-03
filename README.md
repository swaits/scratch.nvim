# Neovim Scratch Buffer Plugin

This plugin provides a simple way to work with scratch buffers in Neovim. It
allows you to quickly open a scratch buffer in your current window or in a new
split window. The plugin also offers the flexibility to configure the default
name of the scratch buffer.

This plugin is based on
[vim-scratch](https://github.com/duff/vim-scratch/tree/master), but written in
lua for Neovim.

## Features

- Open a scratch buffer in the current window.
- Open a scratch buffer in a new split window.
- Automatically switch to an existing scratch buffer if it's already open.
- Configure the default name for the scratch buffer.
- The scratch buffer acts as a temporary workspace and is not backed by a file.
- Emacs-style Lua evaluation: `:Eval` evaluates a line range as Lua and inserts
  the result below it.

## Installation

To install this plugin, you can use your favorite Neovim package manager. For example:

### [lazy](https://github.com/folke/lazy.nvim) (recommended)

```lua
{
  "https://git.sr.ht/~swaits/scratch.nvim",
  lazy = true,
  keys = {
    { "<leader>bs", "<cmd>Scratch<cr>", desc = "Scratch Buffer", mode = "n" },
    { "<leader>bS", "<cmd>ScratchSplit<cr>", desc = "Scratch Buffer (split)", mode = "n" },
  },
  cmd = {
    "Scratch",
    "ScratchSplit",
  },
  opts = {},
}
```

### [pckr](https://github.com/lewis6991/pckr.nvim)

```lua
{
  "https://git.sr.ht/~swaits/scratch.nvim",
  config = function()
    require("scratch").setup()
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'https://git.sr.ht/~swaits/scratch.nvim'
lua require("scratch").setup()
```

### Configuring

The default configuration options are listed below:

```lua
opts = {
  -- The name of the scratch buffer
  buffer_name = "_SCRATCH_",
}
```

## Usage

### Commands

The plugin provides two commands:

- `:Scratch` — Opens or switches to the scratch buffer in the current window.
- `:ScratchSplit` — Opens or switches to the scratch buffer in a new split window.

Inside the scratch buffer there is also a buffer-local command:

- `:Eval` (with an optional range, e.g. visual selection) — Evaluates the lines
  as Lua and inserts the inspected result below them. A lone expression is
  evaluated for its value; for statements, add an explicit `return` for the
  value you want (e.g. `local x = 2` followed by `return x`). Parse and runtime
  errors are shown with `vim.notify`.

### Lua Functions

You can also use the plugin's Lua functions directly:

- `require('scratch').open()` — Equivalent to `:Scratch`.
- `require('scratch').split()` — Equivalent to `:ScratchSplit`.
- `require('scratch').eval({ line1 = 1, line2 = 5 })` — Evaluate a line range
  and insert the result below it. Called with no arguments it uses the current
  line. Wire it up as a global command if you want it outside the scratch
  buffer:

  ```lua
  vim.api.nvim_create_user_command("Eval", require("scratch").eval, { range = true })
  ```

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.
