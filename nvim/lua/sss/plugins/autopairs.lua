local autopairs_status, autopairs = pcall(require, "nvim-autopairs")
if not autopairs_status then
	print("autopairs plugin not found")
	return
end

autopairs.setup({
	check_ts = true, -- enable treesitter
	ts_config = {
		lua = { "string" }, -- dont add pairs in lua string treesitter nodes
		javascript = { "template_string" }, -- dont add pairs in javascript template_string treesitter nodes
		java = false, -- dont check treesitter in java
	},
})

local cmp_autopairs_status, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not cmp_autopairs_status then
	print("cmp autopairs addon not found")
	return
end

local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
	print("cmp plugin not found")
	return
end

-- make autopairs and completion work together
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
