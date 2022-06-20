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

local auto_snips = {}

local math = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local brackets = {
	-- Absolute value
	s({
		trig = "abs",
		hidden = true,
	}, {
		t'\\left\\lvert ', i(1), t' \\right\\rvert ', i(0),
	}, { condition = math }),
	-- Normal
	s({
		trig = "norm",
		hidden = true,
	}, {
		t'\\left\\lVert ', i(1), t' \\right\\rVert ', i(0),
	}, { condition = math }),
	-- Average
	s({
		trig = "avg",
		hidden = true,
	}, {
		t'\\left\\langle ', i(1), t' \\right\\rangle ', i(0),
	}, { condition = math }),
	s({
		trig = "ceil",
		hidden = true,
	}, {
		t'\\left\\lceil ', i(1), t' \\right\\rceil ', i(0),
	}, { condition = math }),
	s({
		trig = "floor",
		hidden = true,
	}, {
		t'\\left\\lfloor ', i(1), t' \\right\\rfloor ', i(0),
	}, { condition = math }),
	s({
		trig = "lr[%)r]",
		hidden = true,
		regTrig = true,
	}, {
		t'\\left( ', i(1), t' \\right) ', i(0),
	}, { condition = math }),
	s({
		trig = "lr[%]s]",
		hidden = true,
		regTrig = true,
	}, {
		t'\\left[ ', i(1), t' \\right] ', i(0),
	}, { condition = math }),
	s({
		trig = "lr[}c]",
		hidden = true,
		regTrig = true,
	}, {
		t'\\left\\{ ', i(1), t' \\right\\} ', i(0),
	}, { condition = math }),
}

return {}, brackets
