import assert from "node:assert/strict";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { spawnSync } from "node:child_process";
import test from "node:test";
import { fileURLToPath } from "node:url";

const hookDirectory = dirname(fileURLToPath(import.meta.url));
const prePush = join(hookDirectory, "pre-push");
const localOid = "1".repeat(40);
const remoteOid = "2".repeat(40);
const zeroOid = "0".repeat(40);

const pushLine = (branch, remoteBranch = branch) =>
  `refs/heads/${branch} ${localOid} refs/heads/${remoteBranch} ${zeroOid}\n`;

const runHook = (remoteUrl, input, cwd) =>
  spawnSync(prePush, ["origin", remoteUrl], {
    cwd,
    encoding: "utf8",
    input,
  });

const runGit = (directory, args) =>
  spawnSync("git", args, {
    cwd: directory,
    encoding: "utf8",
  });

test("accepts main and Conventional branches pushed to PossumTech", () => {
  const result = runHook(
    "git@ssh.possumtech.com:wikitopian/dotfiles.git",
    pushLine("main") + pushLine("feat/workspace-migration"),
  );

  assert.equal(result.status, 0, result.stderr);
});

test("rejects non-Conventional branches pushed to PossumTech", () => {
  const result = runHook(
    "git@ssh.possumtech.com:wikitopian/dotfiles.git",
    pushLine("feature/workspace-migration"),
  );

  assert.equal(result.status, 1);
  assert.match(
    result.stderr,
    /Invalid PossumTech branch 'feature\/workspace-migration'/,
  );
});

test("rejects deletion of PossumTech main", () => {
  const input = `(delete) ${zeroOid} refs/heads/main ${remoteOid}\n`;
  const result = runHook(
    "git@ssh.possumtech.com:wikitopian/dotfiles.git",
    input,
  );

  assert.equal(result.status, 1);
  assert.match(result.stderr, /PossumTech main cannot be deleted/);
});

test("rejects non-fast-forward updates to PossumTech main", async () => {
  const directory = await mkdtemp(join(tmpdir(), "dotfiles-hook-"));

  try {
    assert.equal(runGit(directory, ["init", "-q", "-b", "main"]).status, 0);
    assert.equal(
      runGit(directory, ["config", "user.name", "Hook Test"]).status,
      0,
    );
    assert.equal(
      runGit(directory, [
        "config",
        "user.email",
        "hook-test@example.invalid",
      ]).status,
      0,
    );
    assert.equal(
      runGit(directory, [
        "-c",
        "commit.gpgsign=false",
        "-c",
        "core.hooksPath=/dev/null",
        "commit",
        "--allow-empty",
        "-m",
        "chore: create older state",
      ]).status,
      0,
    );
    const older = runGit(directory, ["rev-parse", "HEAD"]).stdout.trim();

    assert.equal(
      runGit(directory, [
        "-c",
        "commit.gpgsign=false",
        "-c",
        "core.hooksPath=/dev/null",
        "commit",
        "--allow-empty",
        "-m",
        "chore: create newer state",
      ]).status,
      0,
    );
    const newer = runGit(directory, ["rev-parse", "HEAD"]).stdout.trim();
    const input = `refs/heads/main ${older} refs/heads/main ${newer}\n`;
    const result = runHook(
      "git@ssh.possumtech.com:wikitopian/dotfiles.git",
      input,
      directory,
    );

    assert.equal(result.status, 1);
    assert.match(
      result.stderr,
      /PossumTech main accepts fast-forward updates only/,
    );
  } finally {
    await rm(directory, { force: true, recursive: true });
  }
});

test("does not impose PossumTech branch policy on another forge", () => {
  const result = runHook(
    "git@github.com:wikitopian/dotfiles.git",
    pushLine("feature/external-convention"),
  );

  assert.equal(result.status, 0, result.stderr);
});

test("resolves the installed commitlint CLI through npm's global prefix", async () => {
  const directory = await mkdtemp(join(tmpdir(), "dotfiles-hook-"));

  try {
    assert.equal(runGit(directory, ["init", "-q", "-b", "main"]).status, 0);
    assert.equal(
      runGit(directory, ["config", "core.hooksPath", hookDirectory]).status,
      0,
    );

    const valid = runGit(directory, [
      "-c",
      "commit.gpgsign=false",
      "commit",
      "--allow-empty",
      "-m",
      "chore: initialize hook test",
    ]);
    assert.equal(valid.status, 0, valid.stderr);

    const invalid = runGit(directory, [
      "-c",
      "commit.gpgsign=false",
      "commit",
      "--allow-empty",
      "-m",
      "invalid",
    ]);
    assert.equal(invalid.status, 1);
    assert.match(`${invalid.stdout}\n${invalid.stderr}`, /subject-empty/);
    assert.match(`${invalid.stdout}\n${invalid.stderr}`, /type-empty/);
  } finally {
    await rm(directory, { force: true, recursive: true });
  }
});

test("global hooks never destroy a checked-out branch", async () => {
  const directory = await mkdtemp(join(tmpdir(), "dotfiles-hook-"));

  try {
    assert.equal(runGit(directory, ["init", "-q", "-b", "main"]).status, 0);
    assert.equal(
      runGit(directory, [
        "-c",
        "commit.gpgsign=false",
        "commit",
        "--allow-empty",
        "-m",
        "chore: initialize hook test",
      ]).status,
      0,
    );
    assert.equal(
      runGit(directory, ["config", "core.hooksPath", hookDirectory]).status,
      0,
    );

    const checkout = runGit(directory, [
      "switch",
      "-c",
      "feature/external-convention",
    ]);
    assert.equal(checkout.status, 0, checkout.stderr);
    assert.equal(
      runGit(directory, ["branch", "--show-current"]).stdout.trim(),
      "feature/external-convention",
    );
  } finally {
    await rm(directory, { force: true, recursive: true });
  }
});
