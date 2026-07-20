const fs = require("fs");
const { parse } = require("jsonc-parser");

const path = "keybindings.jsonc.mac";

const text = fs.readFileSync(path, "utf8");
const data = parse(text);

data.sort((a, b) => (a.key ?? "").localeCompare(b.key ?? ""));

fs.writeFileSync(path, JSON.stringify(data, null, 2));
