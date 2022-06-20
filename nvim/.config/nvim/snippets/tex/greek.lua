local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node

local in_math = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local greek_sym = ';' -- character to put before latin letter to get greek mapping

-- Greek letters snippets for math mode
local greek_letters = {
	a = "alpha",
	b = "beta",
	c = "chi",
	d = "delta",
	D = "Delta",
	e = "epsilon",
	ve = "varepsilon",
	f = "phi",
	vf = "varphi",
	F = "Phi",
	g = "gamma",
	G = "Gamma",
	h = "eta",
	i = "iota",
	k = "kappa",
	l = "lambda",
	L = "Lambda",
	m = "mu",
	n = "nu",
	p = "pi",
	q = "theta",
	vq = "vartheta",
	Q = "Theta",
	r = "rho",
	s = "sigma",
	vs = "varsigma",
	S = "Sigma",
	t = "tau",
	u = "upsilon",
	U = "Upsilon",
	o = "omega",
	O = "Omega",
	x = "xi",
	X = "Xi",
	y = "psi",
	Y = "Psi",
	z = "zeta"
}

local auto_snips = {}
for latin, greek in pairs(greek_letters) do
	table.insert(
		auto_snips,
		s({
			trig = greek_sym .. latin,
			hidden = true,
		}, {
			t('\\' .. greek),
		}, {
			condition = in_math,
			show_condition = false,
		})
	)
end

return {}, auto_snips
