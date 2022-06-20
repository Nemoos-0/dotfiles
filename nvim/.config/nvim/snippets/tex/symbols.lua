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

local math = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local auto_snips = {}

local symbols = {
	-- Algebra
	["**"] = "\\cdot",
	["\\cdot*"] = "\\cdots",
	["xx"] = "\\times",
	-- Symbols
	["ooo"] = "\\infty",
	-- Relationship symbol
	["~~"] = "\\sim",
	["\\sim~"] = "\\approx",
	["=="] = "\\equiv",
	["<="] = "\\leq",
	[">="] = "\\geq",
	["<<"] = "\\ll",
	[">>"] = "\\gg",
	-- Quantifie
	["all"] = "\\forall",
	["exi"] = "\\exists",
	["nex"] = "\\nexists",
	-- Logic
	["and"] = "\\wedge",
	["oor"] = "\\vee",
	["xor"] = "\\otimes",
	["not"] = "\\neg",
	["=>"] = "\\implies",
	["iff"] = "\\iff",
	-- Function
	["->"] = "\\to",
	["!>"] = "\\mapsto",
	-- Set theory
	["\\\\\\"] = "\\setminus",
	["inn"] = "\\in",
	["subset"] = "\\subset",
	["NN"] = "\\mathbb{N}",
	["ZZ"] = "\\mathbb{Z}",
	["QQ"] = "\\mathbb{Q}",
	["RQ"] = "\\mathbb{R} \\setminus \\mathbb{Q}",
	["RR"] = "\\mathbb{R}",
	["\\mathbb{R}R"] = "\\widetilde{\\mathbb{R}}",
	["CC"] = "\\mathbb{C}",
	-- Geometry
	["paral"] = "\\parallel",
	["perp"] = "\\perp",
	-- Stuff
	["nabl"] = "\\nabla",
}

for trigger, symbol in pairs(symbols) do
	table.insert(
		auto_snips,
		s({
			trig = trigger,
			hidden = true,
		}, {
			t(symbol),
		}, {
			condition = math,
			show_condition = false,
		})
	)
end

local backslash = {
	"sin",
	"arcsin",
	"sinh",
	"cos",
	"arccos",
	"cosh",
	"tan",
	"arctan",
	"tanh",
	"sec",
	"arcsec",
	"sech",
}

for _, trigger in ipairs(backslash) do
	table.insert(
		auto_snips,
		s({
			trig = trigger,
			hidden = true,
		}, {
			t("\\" .. trigger .. " "),
		}, {
			condition = math,
			show_condition = false,
		})
	)
end

return {}, auto_snips
