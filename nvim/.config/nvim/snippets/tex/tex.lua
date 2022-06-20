local ls = require "luasnip"
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

local vec_sym = "mathbf" -- latex vector symbol
local auto_snippets = {}

local check = {}
check.in_math = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end


local sub_super_script = {
	--
	-- Subscript
	--
	-- Single digit subscript
	s({
		trig = "([a-zA-Z])(%d)",
		hidden = true,
		wordTrig = false,
		regTrig = true,
	}, f(function(_, snip)
		return snip.captures[1] .. '_{' .. snip.captures[2] .. '}'
	end, {}), { condition = check.in_math }),
	-- Multi character subscript
	s({
		trig = "_",
		hidden = true,
		wordTrig = false,
	}, {
		t '_{', i(1), t '}', i(0),
	}, { condition = check.in_math }),
	--
	-- Super script
	--
	-- Inverse power
	s({
		trig = "inv",
		hidden = true,
		wordTrig = false,
	}, {
		t '^{-1}',
	}, { condition = check.in_math }),
	-- Square power
	s({
		trig = "sr",
		hidden = true,
		wordTrig = false,
	}, {
		t '^{2}',
	}, { condition = check.in_math }),
	-- Cube power
	s({
		trig = "cb",
		hidden = true,
		wordTrig = false,
	}, {
		t '^{3}',
	}, { condition = check.in_math }),
	-- Multi character super script
	s({
		trig = "^",
		hidden = true,
		wordTrig = false,
	}, {
		t '^{', i(1), t '}', i(0),
	}, { condition = check.in_math }),
}

for _, v in pairs(sub_super_script) do
	table.insert(auto_snippets, v)
end

-- Symbols wrappers

local symb_wrap = {
	[",%."] = vec_sym,
	["%.,"] = vec_sym,
	["vec"] = vec_sym,
	["hat"] = "hat",
	["bar"] = "overline",
	["ddot"] = "ddot",
}

for trig, symb in pairs(symb_wrap) do
	table.insert(
		auto_snippets,
		s({
			trig = "([\\a-zA-Z]+)" .. trig,
			hidden = true,
			wordTrig = false,
			regTrig = true,
		}, {
			f(function(_, snip)
				return "\\" .. symb .. "{" .. snip.captures[1] .. '}'
			end)
		})
	)

	table.insert(
		auto_snippets,
		s({
			trig = "(%s)" .. trig,
			hidden = true,
			wordTrig = false,
			regTrig = true,
		}, {
			f(function(_, snip)
				return snip.captures[1] .. '\\' .. symb .. '{'
			end), i(1), t '}', i(0),
		})
	)
end

-- Custom dot priority since it competes with ddot

table.insert(
	auto_snippets,
	s({
		trig = "(\\[a-zA-Z])" .. "dot",
		hidden = true,
		wordTrig = false,
		regTrig = true,
		priority = 900,
	}, {
		f(function(_, snip)
			return "\\" .. "dot" .. "{" .. snip.captures[1] .. '}'
		end)
	})
)

table.insert(
	auto_snippets,
	s({
		trig = "(%s)" .. "dot",
		hidden = true,
		wordTrig = false,
		regTrig = true,
		priority = 900,
	}, {
		f(function(_, snip)
			return snip.captures[1] .. '\\' .. "dot" .. '{'
		end), i(1), t '}', i(0),
	})
)

-- Symbol in math mode
local random_snippets = {
	--
	-- Operators
	--
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
	}),
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
	}, { condition = check.in_math }),
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
	}, { condition = check.in_math }),
	-- Set
	s({
		trig = "(%s)set",
		hidden = true,
		regTrig = true,
	}, {
		f(function (_, snip)
			return snip.captures[1]
		end),
		t'\\{ ', i(1), t' \\} ', i(0),
	}, { condition = check.in_math }),
}

for _, v in pairs(random_snippets) do
	table.insert(auto_snippets, v)
end

return {
	s(
		"ls",
		fmt([[
			\begin{{itemize}}
				\item {}
			\end{{itemize}}
		]], {
			i(1),
		})
	),
}, auto_snippets
