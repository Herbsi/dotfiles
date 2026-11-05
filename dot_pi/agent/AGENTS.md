# Writing

- When writing something for human consumption (comment, commit message, reply to a prompt), use as few words as possible.
- Pick every word meticulously to reduce the volume to a strict minimum.
- Be down to the point; less is more.

- Avoid superlatives and praise.
- Give me the cold, hard truth.

- Extract recurring or meaningful values into descriptive constants or enums.
- Keep self-explanatory, one-off values inline to avoid clutter.
- If a value comes from a spec (e.g. HTTP 200 OK), use a constant regardless.

- Reduce code indentation.
- Avoid the arrow anti-pattern.
- Leverage early return and continue.

- Keep function names short, below 30 characters.

- Use enums instead of booleans for function parameters.

- Let the reader breathe: add empty lines between logical blocks of code.

- Add a short, to-the-point comment explaining what a block does and why.
- Use examples where possible.
- Propose ASCII drawings to explain complete systems.

- Treat member visibility changes as a breaking design shift.
- Keep all fields and functions private unless the design strictly requires external access.
- Ask me for approval before changing any access modifier.

- Program to levels of abstraction.
- Encapsulate lower-level mechanics (raw hardware I/O, sector parsing, direct socket streams) in a dedicated driver or abstraction layer.
- Expose clean, high-level APIs so calling code works with domain concepts, not raw implementation details.

- Each layer may only communicate with its immediate neighbour below.
- Never punch holes through layers.
- A controller or UI component must never call database queries, raw hardware drivers, or low-level network clients directly.
- Route such calls through the intermediate service or abstraction layer.

- Never touch blocks of code unrelated to the feature you implement.
- Never add comments to code you did not create or modify.
- Minimize the number of changed lines when implementing a feature.

- Always use braces, even on a one-line `if` statement.

- If a prompt indicates a bug fix, write the test first.
- Observe the test failing.
- Then write the fix.
- Then observe the test passing.

# Commit messages

- Write a single line: `scope: summary`.
- The scope names the affected component, as in the Linux kernel.
- Capitalize the summary.
- Do not end the line with a period.
- Keep the line under 50 characters (72 is the hard limit).
- No body; put context into the prompt or the pull request instead.

# Documentation

- Document what is there, not the diff.
- Do not document how code was removed or changed; describe how it works now.
- Documentation lives as close to the source as possible.
- Prefer line-based comments and standardised function documentation.
- Top-level architectural essays are not maintainable for every change.

# General Environment

- OS: NixOS (unstable), Windows (PowerShell)
- Primary languages: C# (.NET 8/10), Python 3.13+, Rust

# Toolchain Commands

- C#: use `dotnet build`, `dotnet test`, `dotnet run`.
- Python: use `pytest` for testing, `ruff` for linting and formatting, `uv` for dependency management.
- Rust: use `cargo check`, `cargo test`, `cargo clippy`.

# Execution Rules

- Keep responses concise.
- Do not run production migrations locally.
- Run static analysis or a linter before declaring a task complete.
- Avoid modifying binary outputs or generated files.
- Write clear unit tests for any new module or refactored component.

# Version control: Jujutsu only

Every project you operate in is a Jujutsu (`jj`) worktree.
A repository may be colocated: a `.git` directory can exist next to `.jj`.
Never invoke `git` directly regardless; use the `jj` equivalents below.

| Instead of              | Use                                  |
|--------------------------|---------------------------------------|
| `git status`             | `jj status`                           |
| `git diff`                | `jj diff`                             |
| `git diff --staged`      | not applicable — jj has no staging area |
| `git add` / `git commit` | not applicable — edits are auto-tracked in the working copy |
| `git commit -m "..."`    | `jj describe -m "..."`                |
| `git commit --amend`     | `jj squash` (into parent) or `jj describe` (message only) |
| `git log`                 | `jj log`                              |
| `git checkout <branch>`  | `jj new <bookmark>` or `jj edit <change>` |
| `git branch`              | `jj bookmark list`                    |
| `git branch <name>`      | `jj bookmark create <name>`           |
| `git switch -c <name>`   | `jj new` then `jj bookmark create <name>` |
| `git stash`                | not needed — just `jj new` to start a fresh change on top |
| `git reset --hard`       | `jj restore` (files) or `jj op restore` (full repo state) |
| `git rebase`               | `jj rebase`                           |
| `git cherry-pick`        | `jj duplicate` or `jj rebase -r`      |
| `git push`                 | `jj git push --bookmark <name>`       |
| `git pull` / `git fetch`  | `jj git fetch`                        |
| `git merge`                | `jj new <rev1> <rev2>`                |

Notes:

- There is no staging area and no index.
- Every edit is automatically part of the current change (the working-copy commit, `@`).
- Use `jj describe -m "..."` to set or update the message of the current change.
- Use `jj new` to start a new change on top of the current one before beginning unrelated work.
- Use `jj log` to inspect history and change IDs before running `jj squash`, `jj rebase`, or `jj edit`.
- If something goes wrong, `jj op log` lists past operations.
- Use `jj op restore <operation-id>` to undo a repo-level operation.
- Use `jj undo` to undo the last single operation.
- Bookmarks are jj's equivalent of Git branches and must be created explicitly with `jj bookmark create`.
- Bookmarks do not move automatically the way Git branches do.
- Never run `jj git init --colocate` unless explicitly asked.
