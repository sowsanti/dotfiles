vim.keymap.set("n", "<leader>fv", "<cmd>Ex<cr>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>nh", "<cmd>nohl<cr>", { desc = "Clear highlights" })
vim.keymap.set("n", "<leader>s|", "<c-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>s-", "<c-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>sm", "<cmd>MaximizerToggle<cr>", { desc = "Maximize current spli" })
vim.keymap.set("n", "<leader>tt", function()
	print(vim.api.nvim_get_option("background"))
	if vim.api.nvim_get_option("background") == "dark" then
		vim.opt.background = "light"
	else
		vim.opt.background = "dark"
	end
end, { desc = "[T]heme [T]oggle (dark/light)" })
vim.keymap.set("n", "<leader>tp", function()
	require("telescope.builtin").colorscheme(require("telescope.themes").get_dropdown())
end, { desc = "[T]theme [P]icker" })

vim.keymap.set("n", "<leader>sk", function()
	require("telescope.builtin").keymaps()
end, { desc = "[S]earch [K]eymap" })
vim.keymap.set("n", "<leader>st", function()
	require("telescope.builtin").filetypes(require("telescope.themes").get_dropdown())
end, { desc = "[S]earch file[T]ypes" })

-- do not copy to register
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "<del>", '"_x')

-- unmap keys
vim.keymap.set("n", "<f3>", "<nop>")
