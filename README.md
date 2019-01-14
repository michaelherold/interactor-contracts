# Interactor::Contracts

[![Build Status](https://travis-ci.org/michaelherold/interactor-contracts.svg)][travis]
[![Code Climate](https://codeclimate.com/github/michaelherold/interactor-contracts/badges/gpa.svg)][codeclimate]
[![Inline docs](http://inch-ci.org/github/michaelherold/interactor-contracts.svg?branch=master)][inch]

[codeclimate]: https://codeclimate.com/github/michaelherold/interactor-contracts
[inch]: http://inch-ci.org/github/michaelherold/interactor-contracts
[travis]: https://travis-ci.org/michaelherold/interactor-contracts

Interactor::Contracts is an extension to the [interactor] gem that gives you
the ability to specify the expectations (expected inputs) and assurances
(expected outputs) of your interactors.

[interactor]: https://github.com/collectiveidea/interactor

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

Let's extend the sample `AuthenticateUser` from the Interactor examples with a
contract that specifies its expectations and assurances.

```ruby
class AuthenticateUser
  include Interactor
  include Interactor::Contracts

  expects do
    required(:email).filled
    required(:password).filled
  end

  assures do
    required(:user).filled
    required(:token).filled
  end

  on_breach do |breaches|
    context.fail!(breaches)
  end

  def call
    if user = User.authenticate(context.email, context.password)
      context.user = user
      context.token = user.secret_token
    else
      context.fail!(:message => "authenticate_user.failure")
    end
  end
end
```

The `expects` block defines the expectations: the expected attributes of the
context prior to the interactor running, along with any predicates that further
constrain the input.

The `assures` block defines the assurances: the expected attributes of the
context after the interactor runs and successfully completes, along with any
predicates the further constrain the output.

Because interactors can have transitive dependencies through the use of
organizers, any other inputs or outputs are ignored from the perspective of
the contract and are passed along to the outgoing (successful) context.

Both `expects` and `assures` wrap [dry-validation], so you can use any
predicates defined in it to describe the expected inputs and outputs of your
interactor.

To hook into a failed expectation or assurance, you can use the `on_breach`
method to defined a breach handler. It should take a 1-arity block that expects
an array of `Breach` objects. These objects have a `property` attribute that
will give you the key that's in breach of its contract. Breaches also have a
`messages` attribute that gives the reasons that property is in breach.

By default, when an `on_breach` consequence is not specified, the contract will
`#fail!` the `Interactor::Context` with the keys that are in breach and arrays
of messages about what the breaches are.

For example, the above interactor acts as follows:

```ruby
result = AuthenticateUser.call({})
#=> #<Interactor::Context email=["email is missing"], password=["password is missing"]>

result.failure?  #=> true
```

[dry-validation]: https://github.com/dryrb/dry-validation

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

* Ruby 2.4
* Ruby 2.5
* Ruby 2.6
* JRuby 9.1

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
