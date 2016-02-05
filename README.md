# Interactor::Contracts

[![Build Status](https://travis-ci.org/michaelherold/interactor-contracts.svg)][travis]
[![Code Climate](https://codeclimate.com/github/michaelherold/interactor-contracts/badges/gpa.svg)][codeclimate]
[![Inline docs](http://inch-ci.org/github/michaelherold/interactor-contracts.svg?branch=master)][inch]

[codeclimate]: https://codeclimate.com/github/michaelherold/interactor-contracts
[inch]: http://inch-ci.org/github/michaelherold/interactor-contracts
[travis]: https://travis-ci.org/michaelherold/interactor-contracts

Interactor::Contracts give you the ability to specify the inputs and outputs of
your interactors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'interactor-contracts'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interactor-contracts

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

When writing code, you can use the helper application [Guard][guard] to
automatically run tests and coverage tools whenever you modify and save a file.
This helps to eliminate the tedium of running tests manually and reduces the
change that you will accidentally forget to run the tests. To use Guard, run
`bundle exec guard`.

Before committing code, run `rake` to check that the code conforms to the style
guidelines of the project, that all of the tests are green (if you're writing a
feature; if you're only submitting a failing test, then it does not have to
pass!), and that the changes are sufficiently documented.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org][rubygems].

[guard]: http://guardgem.org
[rubygems]: https://rubygems.org

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/michaelherold/interactor-contracts.

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
versions:

* Ruby 2.0
* Ruby 2.1
* Ruby 2.2
* JRuby 1.7 (in Ruby 1.9 mode)
* JRuby 9.0

If something doesn't work on one of these versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby versions,
however support will only be provided for the versions listed above.

If you would like this library to support another Ruby version or
implementation, you may volunteer to be a maintainer. Being a maintainer
entails making sure all tests run and pass on that implementation. When
something breaks on your implementation, you will be responsible for providing
patches in a timely fashion. If critical issues for a particular implementation
exist at the time of a major release, support for that Ruby version may be
dropped.

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, that version should be
immediately yanked and/or a new version should be immediately released that
restores compatibility. Breaking changes to the public API will only be
introduced with new major versions. As a result of this policy, you can (and
should) specify a dependency on this gem using the [Pessimistic Version
Constraint][pessimistic] with two digits of precision. For example:

    spec.add_dependency "interactor-contracts", "~> 0.1"

[pessimistic]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[semver]: http://semver.org/spec/v2.0.0.html

## License

The gem is available as open source under the terms of the [MIT License][license].

[license]: http://opensource.org/licenses/MIT.
