# keepin-md.nvim

A lightweight Neovim plugin for enhanced Markdown editing with smart list continuation and indentation management. This plugin aims to make writing Markdown documents in Neovim more efficient and enjoyable.

## Features

- Smart list continuation for various types of Markdown lists:
  - Bullet points (`- `, `+ `, `* `)

https://github.com/user-attachments/assets/0557529e-2fa0-4670-855b-bc84582d45d3

  - Numbered lists (auto-incrementing)

https://github.com/user-attachments/assets/dba9cd84-6805-48b2-94bb-908d7f7394a0
  
  - Checkboxes (`- [ ] `, `+ [ ] `, `* [ ] `)

https://github.com/user-attachments/assets/df123564-1805-47b3-91c8-635b7b72265b

  - Callouts (`> `)

https://github.com/user-attachments/assets/e741ddd8-4b70-4652-9776-a72bf0b236b2


- Intelligent indentation handling:
  - Tab and Shift-Tab support for list indentation
  - Preserves existing indentation levels
  - Works with all list types

https://github.com/user-attachments/assets/12d5c9bb-a77e-477e-a46b-00d73986b1dc


- Auto-termination of empty lists:
  - Automatically breaks list sequence when pressing Enter on an empty list item
  - Removes empty markers to maintain clean document structure

- Markdown-specific functionality:
  - All features are scoped to Markdown files only
  - Preserves default behavior for non-list lines

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    'username/keepin-md.nvim',
    config = function()
      require('keepin-md').setup()
    end
}
```

AI said this can get some configuration options, but it was not. I tested.
Just setup, and checkbox toggle key set as your own.

```lua
vim.keymap.set('n', '<leader>ic', require('keepin-md').checktoggle)
```

## Comparison with bullets.vim

While `keepin-md.nvim` shares some functionality with the established [bullets.vim](https://github.com/bullets-vim/bullets.vim), and that has more fluent features, it takes a different approach:

### Key Differences

1. **Modern Neovim Architecture**:
   - Built specifically for Neovim using Lua
   - More efficient implementation using Neovim's native API
   - Better integration with Neovim's ecosystem

2. **Focus on Markdown**:
   - Specialized for Markdown syntax
   - Support for Markdown-specific features like callouts
   - Cleaner implementation for Markdown use cases

3. **Simplified Design**:
   - Focuses on core functionality without feature bloat
   - More maintainable codebase

### Feature Comparison

| Feature | keepin-md.nvim | bullets.vim |
|---------|----------------|-------------|
| Basic list continuation | ✓ | ✓ |
| Checkbox support | ✓ | ✓ |
| Bullet variations support | ✓ | ✓ |
| Numbered lists | ✓ | ✓ |
| Indentation in insert mode | ✓ | ✓ |
| Empty list termination | ✓ | ✓ |
| Markdown callouts | ✓ | ✗ |
| Checkbox toggle keymap support | ✓ | ✗ |
| Alphabetic lists | ✗ | ✓ |
| Roman numerals | ✗ | ✓ |
| Nested numerical bullets | ✗ | ✓ |

## Credits

This plugin was developed with assistance from Claude AI (Anthropic). The implementation draws inspiration from the Markdown editing ecosystem while providing a modern, Neovim-native solution.

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. I will not be accepting any feature requests or bug reports at this time, though I don't know any programming knowledge.
