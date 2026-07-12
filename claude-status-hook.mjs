#!/usr/bin/env node
// Claude Code hook → per-session state file for the tmux status bar.
// Usage (settings.json hooks): node claude-status-hook.js <EventName>
// States: busy | idle | attention. SessionEnd removes the file.
import { mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const STATE = Object.freeze({
	SessionStart: "idle",
	UserPromptSubmit: "busy",
	PreToolUse: "busy",
	Stop: "idle",
	Notification: "attention",
});

const input = readFileSync(0, "utf8");
if (!input.trim()) process.exit(0);

const { session_id: sessionId } = JSON.parse(input);
if (!sessionId || /[^0-9a-zA-Z-]/.test(sessionId)) process.exit(0);

const dir = join(homedir(), ".cache", "claude-status");
mkdirSync(dir, { recursive: true });
const file = join(dir, sessionId);

const event = process.argv[2];
if (event === "SessionEnd") {
	rmSync(file, { force: true });
	process.exit(0);
}

const state = STATE[event];
if (!state) process.exit(0);
writeFileSync(file, state);
