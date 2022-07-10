local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix

local types = require("luasnip.util.types")
ls.config.set_config {
	history = true,

	updateevents = "TextChanged,TextChangedI",

	enable_autosnippets = true,

	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "<-", "Error" } },
			},
		},
	},
}

ls.add_snippets('all', {
	s('me', fmt([[Matteo Romano]], {}, {})),
})

--- LaTeX

local greek_sym = ';' -- character to put before latin letter to get greek mapping

-- Helper functions

local ts_utils = require('nvim-treesitter.ts_utils')

local function in_math()
	local node = ts_utils.get_node_at_cursor()

	if node then
		print(node:type())
		if (node:type() == "text") then
			node = node:parent()
		end

		if (
			node:type() == "math_environment" or node:type() == "inline_formula" or
				node:type() == "displayed_equation") then
			return true
		end
	end

	return false
end

-- Greek letters

local greek_latin = {
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

local greek_letters = {}
for latin, greek in pairs(greek_latin) do
	table.insert(
		greek_letters,
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

-- Brackets

local brackets = {
	-- Absolute value
	s({
		trig = "abs",
		hidden = true,
	}, {
		t '\\left\\lvert ', i(1), t ' \\right\\rvert ', i(0),
	}, { condition = in_math }),
	-- Normal
	s({
		trig = "norm",
		hidden = true,
	}, {
		t '\\left\\lVert ', i(1), t ' \\right\\rVert ', i(0),
	}, { condition = in_math }),
	-- Average
	s({
		trig = "avg",
		hidden = true,
	}, {
		t '\\left\\langle ', i(1), t ' \\right\\rangle ', i(0),
	}, { condition = in_math }),
	s({
		trig = "ceil",
		hidden = true,
	}, {
		t '\\left\\lceil ', i(1), t ' \\right\\rceil ', i(0),
	}, { condition = in_math }),
	s({
		trig = "floor",
		hidden = true,
	}, {
		t '\\left\\lfloor ', i(1), t ' \\right\\rfloor ', i(0),
	}, { condition = in_math }),
	s({
		trig = "lr[%)br]",
		hidden = true,
		regTrig = true,
	}, {
		t '\\left( ', i(1), t ' \\right) ', i(0),
	}, { condition = in_math }),
	s({
		trig = "lr[%]s]",
		hidden = true,
		regTrig = true,
	}, {
		t '\\left[ ', i(1), t ' \\right] ', i(0),
	}, { condition = in_math }),
	s({
		trig = "lr[}c]",
		hidden = true,
		regTrig = true,
	}, {
		t '\\left\\{ ', i(1), t ' \\right\\} ', i(0),
	}, { condition = in_math }),
}

local su_script = {
	-- Single digit subscript
	s({
		trig = "([a-zA-Z])(%d)",
		hidden = true,
		wordTrig = false,
		regTrig = true,
	}, f(function(_, snip)
		return snip.captures[1] .. '_{' .. snip.captures[2] .. '}'
	end, {}), { condition = in_math }),
	-- Multi character subscript
	s({
		trig = "_",
		hidden = true,
		wordTrig = false,
	}, {
		t '_{', i(1), t '}', i(0),
	}, { condition = in_math }),
	-- Inverse power
	s({
		trig = "inv",
		hidden = true,
		wordTrig = false,
	}, {
		t '^{-1}',
	}, { condition = in_math }),
	-- Square power
	s({
		trig = "sr",
		hidden = true,
		wordTrig = false,
	}, {
		t '^{2}',
	}, { condition = in_math }),
	-- Cube power
	s({
		trig = "cb",
		hidden = true,
		wordTrig = false,
	}, {
		t '^{3}',
	}, { condition = in_math }),
	-- Multi character super script
	s({
		trig = "^",
		hidden = true,
		wordTrig = false,
	}, {
		t '^{', i(1), t '}', i(0),
	}, { condition = in_math }),
}

local others = {
	-- Fraction
	s({
		trig = "^(%s*)(.+)/",
		hidden = true,
		wordTrig = false,
		regTrig = true,
		priority = 900,
	}, {
		f(function(_, snip)
			local space = snip.captures[1]
			local line = snip.captures[2]

			local i = #line
			while (i > 0) do
				local c = line:sub(i, i)

				if (c == ' ') then
					return space .. line:sub(0, i) .. "\\frac{" .. line:sub(i + 1, #line) .. '}{'
				end

				i = i - 1
			end

			return space .. "\\frac{" .. line .. "}{"
		end, {}),
		i(1), t '}', i(0),
	}, { condition = in_math }),
	s({
		trig = "^(%s*)(.+)%)/",
		hidden = true,
		wordTrig = false,
		regTrig = true,
	}, {
		f(function(_, snip)
			local space = snip.captures[1]
			local line = snip.captures[2]
			local depth = 1

			local i = #line
			while (i >= 0) do
				local c = line:sub(i, i)

				if (c == ')') then
					depth = depth + 1
				elseif (c == '(') then
					depth = depth - 1
				elseif (depth == 0) then
					return space .. line:sub(0, i) .. "\\frac{" .. line:sub(i + 2, #line) .. '}{'
				end

				i = i - 1
			end

			return space .. line
		end, {}),
		i(1), t '}', i(0),
	}, { condition = in_math }),
	-- Square root
	s({
		trig = "sq",
		hidden = true,
	}, {
		t '\\sqrt', f(function(args, _)
			if (args[1][1] == '') then return '' else return '[' end
		end, { 1 }), i(1), f(function(args, _)
			if (args[1][1] == '') then return '' else return ']' end
		end, { 1 }), t '{', i(2), t '} ', i(0),
	}, { condition = in_math }),
	-- Set
	s({
		trig = "(%s)set",
		hidden = true,
		regTrig = true,
	}, {
		f(function(_, snip)
			return snip.captures[1]
		end),
		t '\\{ ', i(1), t ' \\} ', i(0),
	}, { condition = in_math }),
}


ls.add_snippets('tex', greek_letters, { type = 'autosnippets', })
ls.add_snippets('tex', brackets, { type = 'autosnippets', })
ls.add_snippets('tex', su_script, { type = 'autosnippets', })
ls.add_snippets('tex', others, { type = 'autosnippets', })
