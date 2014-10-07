---
  tags: bundler, introduction
  languages: ruby
  resources: 2
---

# Using Bundler

# What is Bundler?

Bundler is a way to handle code dependencies. To see why that's a big deal, let's try to understand the problem a bit.

### The problem
Imagine you're writing an amazing app. This app, being built on the shoulders of giants, requires OTHER code to work. If it's a web app, maybe you'll be using the incredible (Sinatra)[http://www.sinatrarb.com/] gem. Need a database? Try the (Sequel)[https://github.com/jeremyevans/sequel] gem.

One way to handle this, is to have a note in your README, with something like, "Hey, install Sinatra and Sequel".

### When disaster strikes

>A patch got applied

>Oh my god, it broke it all

>Taste unemployment
> ### - Steven Nunez

Software is complex. One change to a dependency can completely break your app. We can remedy this by enforcing that we use a specific version of the gem. But this too has it's problems. How do you enforce this? Are you going to trust that everyone has the right version?

No! We're programmers damn it!

![Yes, you!](http://flatiron-web-assets.s3.amazonaws.com/curriculum/who_me.gif)

## Enter bundler

Bundler handles all of this for you. It provides you with a `Gemfile` where you can keep your requirements in one place. The creates a single place for truth in your app.

- Need the Sinatra gem for your project? Add `gem 'sinatra'` your Gemfile.
- Need the Sinatra gem, but at version 1.4.5? Add `gem 'sinatra', '1.4.5'` to your Gemfile.
- Need the Sinatra gem at a version higher than 1.4, but less than 1.5? Add `gem 'sinatra', '~> 1.4.0'`

[
Read more here](http://bundler.io/gemfile.html)

With this, you can make sure everyone working on your app is using the right version. Now to get the code working :-)

# Using Bundler
Getting started with Bundler is super easy. To create a Gemfile, type `bundle init` in your terminal. You'll notice we created one for you in the repo so running `bundle init` will give you an error.

## Anatomy of Bundler files
There's only one file Bundler requires you have, the others are practices we'll use, but could be anything.

- Gemfile - This file is required by Bundler and contains a source, and a list of file requirements. That's all.
- config/environment.rb - This file can be named anything, the environment file is where we'll be loading all of our app's dependencies, from gems to database connections.

- bin/run.rb - This file can be named anything. This file will start our application. This file will require the environment file we created earlier to provide our app with access to our gems.

We'll be using these files in the test suite, so don't rename them.

### Gemfile

The Gemfile is a list of gems your app uses. The Gemfile lets you setup groups, so gems are only loaded in specific instances.

Here's an example Gemfile. This specifies we're ok with the latest version of `sinatra` and only want `pry` in our development environment.

``` ruby
source "https://rubygems.org"

gem "sinatra"

group :development do
  gem "pry"
end
```

After getting all of your gems in your Gemfile, run `bundle install` from your terminal. This will install the listed gems for you. They won't show up in the directory, but they are in your system, and available.

Running `bundle install` also creates a new file: `Gemfile.lock`. This file notes which specific version of the gem was installed.


### config/environment.rb
This file is used to set up our environment. Here we specify which Bundler groups we want to load. The following code is used to load the `default` group (Anything not explicitly in a group), and the `development` group.


``` ruby
require 'bundler/setup'
Bundler.require(:development, :default)
```

### bin/run.rb
This is where the action is. This is where our app logic goes, and where we make our millions.

To take advantage of all of the work we did in the environment file, let's require it here.

``` ruby
require_relative '../config/environment'
```

That's it! Now we can access all of our gems from our `run.rb` file.

# Working on the lab

Follow along with the rspec test.

Using the rspec --fail-fast option will be useful since some of the
tests take a little while to run.

Make sure to read the comments above each test. There are a lot of regular
expressions in the tests, so if something seems like it should be working but
it's not, make sure that the regex isn't being picky. If it seems too picky
feel free to open up a Github issue!

## Resources
* [RailsCasts](http://railscasts.com/) - [#201 Bundler (revised)](http://railscasts.com/episodes/201-bundler-revised)
* [Bundler Docs](http://bundler.io/) - [Bundler with Sinatra](http://bundler.io/sinatra.html)
