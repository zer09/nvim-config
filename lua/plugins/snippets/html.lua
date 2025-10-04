local ls = require("luasnip")

local s, i = ls.snippet, ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local M = {}

table.insert(
	M,
	s(
		"item-input",
		fmt(
			[[
<ion-item>
	<ion-label position="{}">{}</ion-label>
	<ion-input type="{}"{}></ion-input>
</ion-item>
{}
]],
			{ i(1, "floating"), i(2), i(3, "text"), i(4), i(0) }
		)
	)
)

ls.add_snippets("html", M)
