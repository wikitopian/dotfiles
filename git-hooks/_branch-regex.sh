#!/bin/bash

# Shared branch naming convention
# Matches: type/issue-description (e.g., feat/123-ui-fix)
valid_branch_regex="^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)\/[0-9]+-[a-z0-9-]+$"
