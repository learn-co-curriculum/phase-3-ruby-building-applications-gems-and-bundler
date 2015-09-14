# Code Along: Using Bundler

## Objectives

1. Learn about requiring external code libraries, called gems, in your Ruby applications. 
2. Learn how to use Bunlder and a Gemfile to manage gems and their dependencies in your applications. 

## What is Bundler?

Bundler is a way to handle code dependencies. To see why that's a big deal, let's try to understand the problem a bit.

## The problem
Imagine you're writing an amazing app. This app, being built on the shoulders of giants, requires OTHER code to work. If it's a web app, maybe you'll be using the incredible [Sinatra](http://www.sinatrarb.com/) gem. Need a database? Try the [Sequel](https://github.com/jeremyevans/sequel) gem.

One way to handle this, is to have a note in your README, with something like, "Hey, install Sinatra and Sequel".

### When disaster strikes

>A patch got applied

>Oh my god, it broke it all

>Taste unemployment
> ### - Steven Nunez

Software is complex. One change to a dependency can completely break your app. We can remedy this by enforcing that we use a specific version of the gem. But this, too, has its problems. How do you enforce this? Are you going to trust that everyone has the right version?

No! We're programmers damn it!

## Enter bundler

Bundler handles all of this for you. It provides you with a `Gemfile` where you can keep your requirements in one place. The `Gemfile` creates a single place for for gems to be required and versions to be specified.

- Need the Sinatra gem for your project? Add `gem 'sinatra'`to  your Gemfile.
- Need the Sinatra gem, but at version 1.4.5? Add `gem 'sinatra', '1.4.5'` to your Gemfile.
- Need the Sinatra gem at a version higher than 1.4, but less than 1.5? Add `gem 'sinatra', '~> 1.4.0'`

[Read more here](http://bundler.io/gemfile.html)

With this, you can make sure everyone working on your app is using the right version. Now to get the code working :-)

## Instructions

### Using Bundler

Getting started with Bundler is super easy. To create a Gemfile, type `bundle init` in your terminal. You'll notice we created one for you in the repo so running `bundle init` will give you an error.

###  Anatomy of Bundler files
There's only one file Bundler requires you have (Gemfile), the other files are conventional for a typical Ruby application, but not required by the use of Bundler for gem management. 

- Gemfile - This file is required by Bundler and contains a source, and a list of file requirements. That's all.
- config/environment.rb - The environment file is where we'll be loading all of our app's dependencies, from gems to database connections.

- bin/run.rb - This file will start our application. This file will require the environment file we created earlier to provide our app with access to our gems.

We'll be using these files in the test suite, so don't rename them.

### Gemfile

The Gemfile is a list of gems your app uses. The Gemfile lets you setup groups, so gems are only loaded in specific instances. For example, you might a have gem like Pry in your `development` group because you only need to use Pry to debug when you are in the development phase. Your code in production, i.e. when your app is being used by a user, doesn't need to use the Pry gem. 

Here's an example Gemfile. This specifies that we're ok with the latest version of `sinatra` and only want `pry` in our development environment.

``` ruby
source "https://rubygems.org"

gem "sinatra"

group :development do
  gem "pry"
end
```

**Run your test suite with `rsepc` or `learn` to see what gems you'll be adding to your gem file. Add the appropriate gems, specifying their version when necessary, to get the tests passing**.  

After getting all of your gems in your Gemfile, run `bundle install` from your terminal. This will install the listed gems for you. They won't show up in the directory, but they are in your system, and available.

Running `bundle install` also creates a new file: `Gemfile.lock`. This file notes which specific version of the gem was installed.


### config/environment.rb

This file is used to set up our environment. Here we specify which Bundler groups we want to load. The following code is used to load the `default` group (Anything not explicitly in a group, like `development` in your Gemfile), and the `development` group.

**Place the following code in `config/environment.rb`:** 

``` ruby
require 'bundler/setup'
Bundler.require(:default, :development)
```

**Important:** The two arguments that you are passing into the `.require` method *must be passed in in the correct order, shown above*. The test you are trying to pass is testing for order. 

### bin/run.rb

This is where the action is. This is where our app logic goes, and where we make our millions.

To take advantage of all of the work we did in the environment file, let's require it here.

**Place the following code in `bin/run.rb`:**

``` ruby
require_relative '../config/environment'
```

That's it! Now we can access all of our gems from our `run.rb` file.

## Resources
* [RailsCasts](http://railscasts.com/) - [#201 Bundler (revised)](http://railscasts.com/episodes/201-bundler-revised)
* [Bundler Docs](http://bundler.io/) - [Bundler with Sinatra](http://bundler.io/sinatra.html)
