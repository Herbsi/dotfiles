- When writing something intended for human consumption, (comment, commit message, reply to prompt) use as few words as possible. Pick every word meticulously to reduce the volume to a strict minimum. Be down to the point. Less is more.

- Avoid superlatives and praise. Stop telling me I am absolutely right. Give me the cold hard truth.

- Avoid magic numbers and strings by extracting recurring or meaningful values into descriptive constants (const) or enums. Keep self-explanatory, one-off values inline to avoid clutter. If a value comes from a spec (e.g. HTTP 200 OK), use a constant regardless.

- Reduce code indentation. Avoid Arrow Anti-Pattern. Leverage early return and continue.

- Keep function names short. Less than 30 characters.

- Use enums instead of booleans for function parameters.

- Let the reader of the code breathe. Add empty lines between logical blocks of code.

- Add a small, to the point, comment to explain *what* the block does and *why*. Use examples when possible. Propose ASCII drawings to explain complete systems.

- Treat member visibility changes as a breaking design shift. Keep all fields and functions private unless external access is strictly required by the design. Prompt the user for explicit approval before changing any access modifier from private to internal or public.

- Program to levels of abstraction. Lower-level mechanics (e.g., raw hardware I/O, sector parsing, direct socket streams) must be encapsulated in a dedicated driver/abstraction layer. Expose clean, high-level APIs to the rest of the application so calling code works with domain concepts, not raw implementation details.

- Don't touch blocks of code unrelated to the feature you implement. e.g. Don't add comments to a block of code if you did not create it or modify it. As much as possible try to minimize the number of changed lines when implementing a feature.

- Strictly adhere to the layered boundary hierarchy: each layer may only communicate with its immediate neighbor directly below it. Never "punch holes" through layers (e.g., controllers or UI components must never directly call database queries, raw hardware drivers, or low-level network clients; always route through the intermediate service/abstraction layer).

- Always use {}, even on a one-line "if" statement.

When you write a commit message, follow these 7 rules:
Rule 1: Separate the subject line from the body with a single blank line.
Rule 2: Limit the subject line to 50 characters (72 is the absolute hard limit).
Rule 3: Capitalize the first letter of the subject line.
Rule 4: Do not end the subject line with a period.
Rule 5: Follow conventional commits
Rule 6: Wrap the body text manually at 72 characters to prevent Git formatting issues.
Rule 7: Use the body to explain what and why vs. how. Assume the code explains the how;
        the message must explain the context and reasoning. 

- If the prompt indicates that a bug is being fixed, don't write the fix right away. First write the test. Observe it failing. Then write the fix. And observe the test passing.      

Document what's there, not the diff.
Documentation of how code was removed or changed to fix a bug or add a feature is not useful and difficult to maintain; documentation should explain how code works now.

Documentation should live close to the source as possible.
Prefer line-based comments and standardised function documentation.
Top-level sweeping architectural essays are not maintainable for every change.

# General Environment
- OS: Windows (PowerShell)
- Primary Languages: C# (.NET 8/10), Python 3.13+, Rust

# Toolchain Commands
- C#: Use `dotnet build`, `dotnet test`, `dotnet run`
- Python: Use `pytest` for testing, `ruff` for linting and formatting, `uv` for dependency management
- Rust: Use `cargo check`, `cargo test`, `cargo clippy`

# Execution Rules
- Keep responses concise.
- sDo not run production migrations locally.
- Always run static analysis/linter before declaring a task complete.
- Avoid modifying binary outputs or generated files.
- Write clear unit tests for any new module or refactored component.

## Version control: Jujutsu only

Every project you operate in is a Jujutsu (`jj`) worktree.
There is no `.git` directory and no colocated Git repository.
Git commands will fail — never invoke `git`.

Use these `jj` equivalents:

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
- Every edit is automatically part of the current change (the working-copy commit, `@`) — there is no need to `add` or `commit` before running `jj diff` or `jj status`.
- Use `jj describe -m "..."` to set or update the message of the current change.
- Use `jj new` to start a new change on top of the current one before beginning unrelated work.
- Use `jj log` to inspect history and change IDs before running `jj squash`, `jj rebase`, or `jj edit`.
- If something goes wrong, `jj op log` and `jj op restore <operation-id>` undo repo-level operations; `jj undo` undoes the last single operation.
- Bookmarks are jj's equivalent of Git branches and must be created explicitly (`jj bookmark create`) — they do not move automatically the way Git branches do.
- Never attempt `jj git init --colocate` unless explicitly asked — this project is jj-only by design, not a colocated Git+jj repo.
