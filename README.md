# Boethius

Boethius aims to be an automated, high-quality PDF generator. 
When completed, it will accept a hash specifying book files, 
XML conversion files, and such settings as margin sizes and heading styles.

The backend is ConTeXt.

## Development goals

Boethius does not yet produce PDFs.

Over time converters for TEI formats from various public-domain
sources will be added under `book_sources/tei`, along with a book or
two for testing each converter. A markdown converter will be added as
well.

A JSON API might be added in the future.

The number of options for customizing books will increase over time.

Some of the logic might be moved into LuaTeX files in the future.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'boethius'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install boethius

## Usage

The TESTDATA hash in `test/test_helper.rb` should show the proper format for data. To make a new ConTeXt source file, call `@tex = Tex.new(your_hash)` and `@tex.generate`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

There will be great rejoicing over any bug reports or pull requests on
GitHub at https://github.com/Lactantius/boethius.

It seems fashionable these days to have some complex code of conduct.
The code of conduct here is more simple. Be polite and courteous.

## License

This project is licensed under the [GNU
AGPLv3](https://en.wikipedia.org/wiki/GNU_Affero_General_Public_License).

Simple, non-legal explanation: While the GPL requires source code
availability if the program is distributed, the AGPLv3 also requires
it if the program is executable over a public network.

For example, if Boethius or a derivative work were put into the
backend of a website, the source code would have to be offered.

The intention of this is _not_ to offer dual-licensing at any time in
the future.

Besides that, you can do with it as you please.

## Acknowledgements

The authors of Ruby, Bundler, Rake, ConTeXt, LuaTeX, Minitest, Linux,
Solus, Vim, and all the free software tools that made life easier.

Some code snippets are copied shamelessly from the prawn project.
