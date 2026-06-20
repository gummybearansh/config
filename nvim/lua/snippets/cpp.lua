local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	-- The trigger is "cp". Type 'cp' then press Enter (or C-K depending on setup)
	s("cp", {
		t({
      "#include <bits/stdc++.h>",
      "",
			"#define ll long long",
      '#define dbg(v) cout << "Line(" << __LINE__ << ") -> " << #v << " = " << (v) << endl;',
      "",
			"using namespace std;",
			"",
			"void solve() {",
			"\t",
		}),
		i(1, ""), -- Cursor jumps here first
		t({
			"",
			"}",
			"",
			"int main() {",
			"\tios_base::sync_with_stdio(false);",
			"\tcin.tie(NULL);",
			"\tint t; cin >> t;",
			"\twhile(t--) {",
			"\t\tsolve();",
			"\t}",
			"\treturn 0;",
			"}",
		}),
	}),
}
