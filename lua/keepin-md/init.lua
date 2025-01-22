local M = {}

function M.checktoggle()
    local line = vim.api.nvim_get_current_line()

    -- Patterns for different checkbox states
    local patterns = {
        unchecked = "^(%s*)%- %[ %]",
        checked = "^(%s*)%- %[x%]",
    }

    -- Get the current date in YYYY-MM-DD format
    local current_date = os.date("%Y-%m-%d")

    -- Get the indentation if any
    local indent = line:match("^%s*") or ""

    -- Check current state and transform
    if line:match(patterns.unchecked) then
        -- Check if line already has a date pattern at the end
        local has_date = line:match("%✅%s+%d%d%d%d%-%d%d%-%d%d%s*$")
        if has_date then
            -- If it has a date, update it
            local new_line = line:gsub(patterns.unchecked, indent .. "- [x]")
            new_line = new_line:gsub("%✅%s+%d%d%d%d%-%d%d%-%d%d%s*$", "✅ " .. current_date)
            vim.api.nvim_set_current_line(new_line)
        else
            -- If no date, add new one
            local new_line = line:gsub(patterns.unchecked, indent .. "- [x]")
            new_line = new_line .. " ✅ " .. current_date
            vim.api.nvim_set_current_line(new_line)
        end
    elseif line:match(patterns.checked) then
        -- Remove the date when unchecking
        local new_line = line:gsub(patterns.checked, indent .. "- [ ]")
        -- Remove the date and checkmark
        new_line = new_line:gsub("%s*✅%s+%d%d%d%d%-%d%d%-%d%d%s*$", "")
        vim.api.nvim_set_current_line(new_line)
    end
end

-- -- Function to toggle checkbox state
-- function M.checktoggle()
--   local line = vim.api.nvim_get_current_line()
--
--   -- Patterns for different checkbox states
--   local patterns = {
--     unchecked = "^(%s*)%- %[ %]",
--     checked = "^(%s*)%- %[x%]",
--   }
--
--   -- Get the indentation if any
--   local indent = line:match("^%s*") or ""
--
--   -- Check current state and transform
--   if line:match(patterns.unchecked) then
--     -- Convert unchecked to checked
--     local new_line = line:gsub(patterns.unchecked, indent .. "- [x]")
--     vim.api.nvim_set_current_line(new_line)
--   elseif line:match(patterns.checked) then
--     -- Convert plain list item to unchecked
--     local new_line = line:gsub(patterns.checked, indent .. "- [ ]")
--     vim.api.nvim_set_current_line(new_line)
--   end
-- end

-- Default configuration
local config = {
    -- Whether to enable the plugin for all markdown files by default
    enable_by_default = true,
    -- The patterns to match markdown files
    patterns = { "*.md", "*.markdown" },
    -- Whether to preserve exact spacing in callout prefixes
    preserve_spacing = true,
}

-- Modified get_line_type function
local function get_line_type(line)
    -- Check for callout
    if line:match("^>%s") then
        return "callout"
    end
    -- Check for checkbox (must check before bullet)
    if line:match("^%s*[%-%*%+]%s%[[%s?xX]%]%s") then
        return "checkbox"
    end
    -- Check for bullet list with multiple markers
    if line:match("^%s*[%-%*%+]%s") then
        return "bullet"
    end
    -- Check for numbered list
    if line:match("^%s*%d+%.%s") then
        return "numbered"
    end
    return "text"
end

-- Get next number for numbered list
local function get_next_number(line)
    local current_num = tonumber(line:match("^%s*(%d+)%."))
    return current_num and (current_num + 1) or 1
end

-- Modified get_marker function
local function get_marker(line, line_type)
    if line_type == "callout" then
        return "> "
    elseif line_type == "checkbox" then
        -- Preserve the original marker type (-, *, or +)
        local marker = line:match("^%s*([%-%*%+])%s%[")
        return (marker or "-") .. " [ ] "
    elseif line_type == "bullet" then
        -- Preserve the original marker type (-, *, or +)
        return line:match("^(%s*[%-%*%+]%s)")
    elseif line_type == "numbered" then
        local num = get_next_number(line)
        return num .. ". "
    end
    return ""
end

-- Modified is_empty_formatted_line function
local function is_empty_formatted_line(line, line_type)
    if line_type == "callout" then
        return line:match("^>%s*$")
    elseif line_type == "checkbox" then
        return line:match("^%s*[%-%*%+]%s%[[%s?xX]%]%s*$")
    elseif line_type == "bullet" then
        return line:match("^%s*[%-%*%+]%s*$")
    elseif line_type == "numbered" then
        return line:match("^%s*%d+%.%s*$")
    end
    return false
end

-- Get indentation level of current line
local function get_indent_level(line)
    return #(line:match("^%s*") or "")
end

-- Get next number for numbered list
local function get_next_number(line)
    local current_num = tonumber(line:match("^%s*(%d+)%."))
    return current_num and (current_num + 1) or 1
end

-- Handle <CR> keypress
local function handle_enter()
    local curr_line = vim.api.nvim_get_current_line()
    local curr_line_num = vim.api.nvim_win_get_cursor(0)[1] - 1
    local line_type = get_line_type(curr_line)

    -- If line is empty (except for marker), break the sequence
    if is_empty_formatted_line(curr_line, line_type) then
        -- Delete the empty marker and add a blank line
        vim.api.nvim_buf_set_lines(0, curr_line_num, curr_line_num + 1, false, { "" })
        vim.api.nvim_feedkeys("\r", "n", false)
        return
    end

    -- Get the marker to continue
    local marker = get_marker(curr_line, line_type)
    if marker ~= "" then
        -- Preserve indentation without forcing increase
        -- local indent = curr_line:match("^(%s*)")
        if line_type == "callout" then
            marker = marker -- Keep callout marker as is (just "> ")
        else
            -- For lists, preserve exact indentation
            marker = marker:match("^%s*(.-)%s*$") .. " "
        end
        vim.api.nvim_feedkeys("\r" .. marker, "n", false)
        return
    end

    -- Default behavior
    vim.api.nvim_feedkeys("\r", "n", false)
end

-- Handle Tab keypress
local function handle_tab(reverse)
    local curr_line = vim.api.nvim_get_current_line()
    local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
    local line_type = get_line_type(curr_line)

    -- Only handle indentation for list items
    if line_type ~= "text" and line_type ~= "callout" then
        local current_indent = get_indent_level(curr_line)
        local new_indent

        if reverse then
            -- Shift-Tab: decrease indent
            new_indent = math.max(0, current_indent - 4)
        else
            -- Tab: increase indent
            new_indent = current_indent + 4
        end

        -- Apply new indentation while preserving the rest of the line
        local content = curr_line:match("^%s*(.*)$")
        local new_line = string.rep(" ", new_indent) .. content
        vim.api.nvim_buf_set_lines(0, line_num, line_num + 1, false, { new_line })
        vim.api.nvim_win_set_cursor(0, { line_num + 1, cursor_col + new_indent })
        return
    end

    -- Default behavior for non-list lines
    local key = reverse and "<S-Tab>" or "<Tab>"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", false)
end

-- Setup function
function M.setup(opts)
    -- Merge user config with defaults
    config = vim.tbl_deep_extend("force", config, opts or {})

    -- Set up autocommands
    local augroup = vim.api.nvim_create_augroup("MarkdownFormatter", { clear = true })

    -- Set up keymaps for markdown files
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "markdown",
        callback = function()
            -- Map <CR> to handle_enter
            vim.keymap.set("i", "<CR>", handle_enter, { buffer = true })

            -- Map <Tab> and <S-Tab> to handle_tab
            vim.keymap.set("i", "<Tab>", function() handle_tab(false) end, { buffer = true })
            vim.keymap.set("i", "<S-Tab>", function() handle_tab(true) end, { buffer = true })
        end
    })
end

return M
