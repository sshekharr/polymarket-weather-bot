/**
 * Fails npm install if known-malware or blocklisted package names appear in package.json.
 * Runs automatically via package.json "preinstall".
 */
const fs = require("fs");
const path = require("path");

const BLOCKED = [
  "sleek-pretty",
  "pinno-loggers",
  "terminal-logger-utils",
  "pino-pretty-log",
  "pino-pretty-logs",
];

const root = path.join(__dirname, "..");
const pkgPath = path.join(root, "package.json");
const pkg = JSON.parse(fs.readFileSync(pkgPath, "utf8"));

const sections = ["dependencies", "devDependencies", "optionalDependencies"];
const found = [];

for (const section of sections) {
  const deps = pkg[section];
  if (!deps || typeof deps !== "object") continue;
  for (const name of Object.keys(deps)) {
    if (BLOCKED.includes(name)) found.push(`${section}: ${name}`);
  }
}

if (found.length) {
  console.error("\n[SECURITY] Blocked package(s) in package.json:");
  found.forEach((f) => console.error("  -", f));
  console.error("\nRemove them. See docs/SECURITY_AUDIT.md\n");
  process.exit(1);
}
