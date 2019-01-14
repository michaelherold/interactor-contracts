# frozen_string_literal: true

# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_body.include?('[ci skip]')

# Checks whether library code was changed
code_changed = git.modified_files.grep(/lib/).any?

# Checks whether test code was changed
tests_changed = git.modified_files.grep(/spec/).any?

# Checks for a change log entry when code changes
changelog.check if (code_changed || tests_changed) && !declared_trivial

# Checks for well-formed commit messages
commit_lint.check

# Runs the code linter
rubocop.lint

# vim: ft=ruby
