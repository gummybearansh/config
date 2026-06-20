local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	-- The trigger is "cp". Type 'cp' then press your expansion key
	s("cp", {
		t({
			"import sys",
			"",
			"# Fast I/O",
			"input = sys.stdin.readline",
			"",
			"# Prevent crashes on deep recursion (Graphs/Trees)",
			"sys.setrecursionlimit(200000)",
			"",
			"def solve():",
			"\t",
		}),
		i(1, "pass"), -- Cursor lands here first so you can start typing
		t({
			"",
			"",
			"if __name__ == '__main__':",
			"\tt = int(input().strip())",
			"\tfor _ in range(t):",
			"\t\tsolve()",
		}),
	}),
}
