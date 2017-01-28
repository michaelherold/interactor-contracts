# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_body.include?("[ci skip]")

# Checks whether library code was changed
code_changed = git.modified_files.grep(/lib/).any?

# Checks whether test code was changed
tests_changed = git.modified_files.grep(/spec/).any?

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("Pull request is a work in progress") if github.pr_title.include?("[WIP]")

# Warn when there is a big PR
warn("Big pull request") if git.lines_of_code > 500

# Checks for a change log entry when code changes
changelog.check if (code_changed || tests_changed) && !declared_trivial

# Checks for well-formed commit messages
commit_lint.check

# Runs the code linter
rubocop.lint

# vim: ft=ruby
