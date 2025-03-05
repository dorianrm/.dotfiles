local actions = require("telescope.actions")
local telescopeConfig = require("telescope.config")
local utils = require("telescope.utils")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.obsidian/*")

require("telescope").setup({
	defaults = {
		vimgrep_arguments = vimgrep_arguments,
		file_ignore_patterns = {
			"bin/.*",
		},
		-- path_display = {
			-- "smart",
      -- "truncate = 10",
			-- shorten = {
			--   len = 1,
			--   exclude = {-1, -2, -3}
			-- }
		-- },
    path_display = function(opts, path)
      local display = path

      local parts = {}
      for part in string.gmatch(path, "[^/\\]+") do
          table.insert(parts, part)
      end

      -- If there are 4 or fewer parts, return the original path
      if #parts > 4 then
      -- Get the last 4 parts
        local truncated = {parts[#parts-3], parts[#parts-2], parts[#parts-1], parts[#parts]}

        -- Join with forward slashes (you can change this to backslashes if needed)
        display = ".../" .. table.concat(truncated, "/")
      end

      local tail = require("telescope.utils").path_tail(path)
      return string.format("%s  ||  (%s)", tail, display)
    end,
		sorting_strategy = "ascending",
		layout_strategy = "vertical",
		layout_config = {
			vertical = {
				prompt_position = "top",
			},
		},
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
	pickers = {
		find_files = {
			find_command = {
				"rg",
				"--files",
				"--hidden",
				"--glob",
				"!**/.git/*",
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.lsp_references, { desc = "[S]earch [R]efereces" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })

-- git
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "[G]it s[T]atus" })
-- vim.keymap.set('n', '<leader>gs', builtin.git_stash, { desc = '[G]it [S]tash list' })
