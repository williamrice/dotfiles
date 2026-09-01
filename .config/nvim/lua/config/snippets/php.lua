local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	-- PHP open/close tags
	s("php", {
		t("<?php "),
		i(1),
		t(" ?>"),
	}),

	-- WordPress debug with print_r
	s("debug", {
		t({ "echo '<pre>';" }),
		t({ "", "print_r(" }),
		i(1, "var_name"),
		t({ ");" }),
		t({ "", "wp_die();" }),
	}),
}
