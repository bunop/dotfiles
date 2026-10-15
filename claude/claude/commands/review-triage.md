---
description: Triage the review comments of a pull request, implement the valid ones, push, and comment on the PR with what changed and what did not
argument-hint: [PR number or URL]
---

# review-triage

Triage the review comments of a PR: each point is a claim to verify, not an order to execute.

## 0. Pick the PR
- If `$ARGUMENTS` is not empty, it is the PR number or URL.
- Otherwise use the PR of the current branch: `gh pr view --json number,url,headRefName`.
- If there is no PR for the current branch, stop and ask which one.

Make sure the working tree is on the PR's head branch before changing anything (`gh pr checkout <n>` if not, once the tree is clean).

## 1. Collect everything
The PR has three comment sources; read all of them:
```bash
gh pr view <n> --json comments,reviews,reviewDecision
gh api repos/<owner>/<repo>/pulls/<n>/comments      # inline review comments
```
`gh pr view --json` can return a placeholder such as `<<ccr:...>>` instead of a long body. When that happens fetch the body directly: `gh api repos/<owner>/<repo>/issues/comments/<id> --jq .body`.

## 2. Verify each point before deciding
A bot usually reads only the diff and runs nothing. For every point, check it against the repository and against what was already verified in the session (test runs, production checks, decisions the user made):
- open the file and line it cites; does the problem exist as described?
- does it contradict something already measured or decided? (then it is probably wrong or outdated: say which fact)
- is the cost of the fix proportionate (a one-line guard) or does it add scope (new feature, symmetric teardown nobody needs yet)?

Classify each point:
- **valid**: implement the smallest fix.
- **partly valid**: implement the part that holds, say what was left out and why.
- **wrong / already handled**: no change; give the evidence (file:line, command output, earlier decision).
- **valid but out of scope**: no change now; say it is a conscious deferral, and offer an issue if it matters.

Do not accept a point just because a reviewer raised it, and do not reject one just to avoid work. A claim the review got wrong can still expose a stale PR description: fix that too.

## 3. Implement and verify
- Make the fixes, then run what proves them (tests, `--check`, a real run on the safe environment, idempotence rerun). Do not claim a fix works without running it.
- Commit separately from the feature commits, following the repository's commit convention (use the `gitmoji-commits` skill when the repo uses gitmoji), then push.
- If the PR description is now inaccurate (wrong rollout statement, new test results), update it with `gh pr edit --body-file`.

## 4. Comment on the PR
Right after the push of the fixes, post one summary comment on the PR:
```bash
gh pr comment <n> --body-file <file in the scratchpad>
```
The comment explains what was changed and what was not, one entry per review point:
- the verdict: implemented / partly implemented / not needed / deferred
- the reason, with the evidence for every "not needed" or "deferred" (file:line, command output, earlier decision)
- for implemented points, the hash of the fixing commit

If nothing was changed (no commit, no push), still post the comment, without hashes. Write it in the language of the existing PR discussion, defaulting to the language of the conversation.

## 5. Report
Answer in the user's language with one line per point: the verdict (done / not needed / deferred) and the reason, with the evidence for every "not needed". Finish with what was committed, the link to the PR comment, and what is still unchecked.

## Rules
- The summary comment of step 4 is expected: invoking this command authorizes it. Do not post anything else: no inline replies to single threads, no resolving threads, no re-review requests unless the user asks. Offer them instead, with the draft text.
- Never apply production changes as part of the triage.
- Keep nits proportionate: a cheap guard is fine, a refactor for style is not.
