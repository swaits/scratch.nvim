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

### Lua Functions

You can also use the plugin's Lua functions directly:

- `require('scratch').open()` — Equivalent to `:Scratch`.
- `require('scratch').split()` — Equivalent to `:ScratchSplit`.

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.
