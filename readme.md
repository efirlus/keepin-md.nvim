# keepin-md.nvim

A lightweight Neovim plugin for enhanced Markdown editing with smart list continuation and indentation management. This plugin aims to make writing Markdown documents in Neovim more efficient and enjoyable.

## Features

- Smart list continuation for various types of Markdown lists:
  - Bullet points (`- `)
  - Checkboxes (`- [ ] `)
  - Numbered lists (auto-incrementing)
  - Callouts (`> `)

- Intelligent indentation handling:
  - Tab and Shift-Tab support for list indentation
  - Preserves existing indentation levels
  - Works with all list types

- Auto-termination of empty lists:
  - Automatically breaks list sequence when pressing Enter on an empty list item
  - Removes empty markers to maintain clean document structure

- Markdown-specific functionality:
  - All features are scoped to Markdown files only
  - Preserves default behavior for non-list lines

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use('username/keepin-md.nvim')
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    'username/keepin-md.nvim',
    ft = { 'markdown' },
}
```

## Setup

```lua
require('keepin-md').setup({
    -- Optional configuration
    file_patterns = { "*.md", "*.markdown" },
    markers = {
        callout = "> ",
        bullet = "- ",
        checkbox = "- [ ] ",
    }
})
```

## Comparison with bullets.vim

While `keepin-md.nvim` shares some functionality with the established [bullets.vim](https://github.com/bulets-vim/bullets.vim), and that has more fluent features, it takes a different approach:

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
| Numbered lists | ✓ | ✓ |
| Indentation in insert mode | ✓ | ✓ |
| Empty list termination | ✓ | ✓ |
| Markdown callouts | ✓ | ✗ |
| Alphabetic lists | ✗ | ✓ |
| Roman numerals | ✗ | ✓ |
| Nested numerical bullets | ✗ | ✓ |

## Credits

This plugin was developed with assistance from Claude AI (Anthropic). The implementation draws inspiration from the Markdown editing ecosystem while providing a modern, Neovim-native solution.

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. I will not be accepting any feature requests or bug reports at this time, though I don't know any programming knowledge.