return {
	math = function()
		return vim.fn["vimtex#syntax#in_mathzone"]() == 1
	end
}
