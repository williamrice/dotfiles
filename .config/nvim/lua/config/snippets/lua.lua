local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

-- lua gh require
return {
	s("gh", {
		t("local gh = require('config.utils').gh"),
	}),
}
