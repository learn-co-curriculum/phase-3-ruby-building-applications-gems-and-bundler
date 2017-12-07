# Code Along: Using Bundler

## Objectives

1. Learn about requiring external code libraries, called gems, in your Ruby applications.
2. Learn how to use Bundler and a Gemfile to manage gems and their dependencies in your applications.



### What are RubyGems?

Nothing you ever write will be 100% your code. While you probably haven't noticed it, every day you use somebody else's code. You didn't write your text editor, you didn't write Ruby, you didn't write your operating system. Those are the types of things that regular users interact with. As a developer there is a new set of outside code you will work with: Libraries. Libraries (or "gems" in Ruby parlance) are just bundles of code that someone else wrote for you to integrate into your code base. For example, remember rspec? That's a gem. Instead of everyone having to re-invent a way to do testing for ruby, initially one person and now hundreds of people have worked together to make a single amazing library that everyone can use. It's open source, and you integrate it using the RubyGems tool. Head over to rubygems.org. There are thousands of gems you can pull from that will make your life easier. That is the power of open source. Together we can create something no single person could make.

#### How to find a gem?

Google is often a good starting place. Let's assume we are looking for a gem to send emails. We could google `ruby gem to send emails`. Another option is to go to `https://rubygems.org/search/advanced` or `https://rubylaser.org/` and enter `email` in the search bar.


#### How to choose the right gem?

Let's assume we decided to search `https://rubygems.org` for the right gem. Let's head to their advanced search interface `https://rubygems.org/search/advanced` and search for `email rails` using the description field. The advanced search interface will give us more flexibility in the way we search for the ideal gem. 

![](https://curriculum-content.s3.amazonaws.com/web-development/ruby/rubygems-advanced-search.png)

You might be asking which one is the best? How to choose from those many options? Which one should I use for my application?

![](https://curriculum-content.s3.amazonaws.com/web-development/ruby/rubygem-advanced-search-results.png)

First of all, if you have a Rails application you should use gems built for Rails, like the `actionmailer` gem. How do we know it is a Rails application? If you view the GitHub repository for `actionmailer` you'll notice this gem lives under the `rails/rails` repository.

![](https://curriculum-content.s3.amazonaws.com/web-development/ruby/actionmailer-github.png)

We don't have a Rails application, how do we decide what is the right gem? The easiest way to do this is by inspecting the total fork count or by going to the Github repository. Some questions that will help with making your decision:

* How many people forked the repo?
* How many people have contributed to the repo?
* How many open issues does the repo have?
* Does the repo have a test suite?

#### How to install a gem?

We are going to use the `mail` gem.

##### How to 'require' a gem
One way of installing it would be to run `gem install mail` in your terminal and then `require` the gem in the file where you want to use that gem.

For example:

```ruby
require 'mail'
```

##### How to add the gem to your Gemfile
The other way, assuming you have an application, is to add the following to your `Gemfile`:

 ``` ruby
 gem 'mail', '~> 2.6', '>= 2.6.3'
 ```
This line of code says that we're using the `mail` gem, and then says that we want to use any version of the gem above 2.6.3. Why do we need to specify a version? Well, what would happen if a major change was made to the gem and suddenly it didn't work with your app? Locking in the version prevents your app from breaking based on a gem change.

### Gem Versions

Just like any software, gems have updated versions. Let's take the example above:

```ruby
 gem 'mail', '~> 2.6', '>= 2.6.3'
 ```

Let's take the first part of the versioning `'~> 2.6'`. All gems go through several different series of updates: a major version change or a minor version change.

A major version change is reflected by the first number (reading from left to right). Major version changes don't have to be backwards compatible. This means that if your app is built using version 1, and the gem updates to version 2, the new version can potentially break your app.

A minor version change is reflected by the number after the first decimal point. All minor version changes have to be backwards compatible. This means that while version 1.2 has more functionality than version 1.0, all the features in 1.0 are supported in 1.2.

The number after the second decimal point reflects a patch, which is a change to a gem to fix a bug but not introduce new functionality. `1.2.3` means major version 1, minor version 2, and a patch version 3.

The `~>` means any minor version change above the one listed. `'~> 2.6'` means any minor version above 2.6. 2.7, 2.8, and 2.9 would work (including patches); but version 3.0 wouldn't work because it indicates a new major version.

The `mail` gem has a second specification `'>= 2.6.3'`. This means any version greater than or equal to `2.6.3`. Because the `mail` gem has two specifications, both have to be true, so this gem couldn't use version `2.6` because it's lower than `2.6.3`.

### Gemfile

The Gemfile is a list of gems your app uses. The Gemfile lets you setup groups, so gems are only loaded under specific circumstances. For example, you might have a gem like Pry in your `development` group because you only need to use Pry to debug when you are in the development phase. Your code in `production`, i.e. when your app is being used by a user, doesn't need to use the Pry gem.

Here's an example Gemfile.

```ruby
source "https://rubygems.org"

gem "sinatra"

group :development do
  gem "pry"
end
```

#### The Group Syntax

The group syntax uses the keyword `group`, followed by the app environment as a symbol (`:development`, `:test`, and `:production` are the standard environments), followed by the keyword `do`. Inside the block, we list all the gems specific to that group.

In the example above, we grouped `pry` in the development environment. This means that pry isn't accessible in testing or in production. There are a lot of gems specific to the testing environment, like rspec and capybara. You don't need to run tests in the development or production environments, so you don't need those gems loaded there. Groups allow us to specify which environment needs our gems.

#### The Hash Syntax

There is another format with which to group gems in your Gemfile:

```ruby
gem "pry", :group => "development"
```

This is called the hash syntax.


### What is Bundler?

Bundler is a way to handle code dependencies. To see why that's a big deal, let's try to understand the problem a bit.

### The problem
Imagine you're writing an amazing app. This app, being built on the shoulders of giants (gems), requires OTHER code to work. If it's a web app, maybe you'll be using the incredible [Sinatra](http://www.sinatrarb.com/) gem. Need a database? Try the [Sequel](https://github.com/jeremyevans/sequel) gem.

One way to handle this is to have a note in your README with something like, "Hey, install Sinatra and Sequel".

#### When disaster strikes

>A patch got applied

>Oh my god, it broke everything

>Taste unemployment
> #### - Steven Nuñez

Software is complex. One change to a dependency can completely break your app. We can remedy this by enforcing that we use a specific version of the gem. But this, too, has its problems. How do you enforce this? Are you going to trust that everyone has the right version?

No! We're programmers, dammit!

### Enter bundler

[Bundler](http://bundler.io/) handles all of this for you. It provides you with a `Gemfile` where you can keep your requirements in one place. The `Gemfile` creates a single place for gems to be required and versions to be specified.

- Need the Sinatra gem for your project? Add `gem 'sinatra'`to  your Gemfile.
- Need the Sinatra gem, but at version 1.4.5? Add `gem 'sinatra', '1.4.5'` to your Gemfile.
- Need the Sinatra gem at a version higher than 1.4, but less than 1.5? Add `gem 'sinatra', '~> 1.4.0'`

[Read more here](http://bundler.io/gemfile.html)

With this, you can make sure everyone working on your app is using the right version. Now to get the code working :-)

## Code along

### Using Bundler

Getting started with Bundler is super easy. To create a Gemfile, type `bundle init` in your terminal. You'll notice we created one for you in the repo so running `bundle init` will give you an error.

###  Anatomy of Bundler files
There's only one file Bundler requires you have (Gemfile). The other files are conventional for a typical Ruby application, but not required by the use of Bundler for gem management.

- Gemfile - This file is required by Bundler and contains a source, and a list of file requirements. That's all.
- config/environment.rb - The environment file is where we'll be loading all of our app's dependencies, from gems to database connections.

- bin/run.rb - This file will start our application. This file will require the environment file we created earlier to provide our app with access to our gems.

We'll be using these files in the test suite, so don't rename them.

### Gemfile

Add this code to your `Gemfile`

```ruby
source "https://rubygems.org"
gem "rspec"
gem "sinatra"

group :development do
  gem "pry"
end
```

**Run your test suite with `rspec` or `learn` to see what gems you'll be adding to your gem file. Add the appropriate gems, specifying their version when necessary, to get the tests passing**.

After getting all of your gems in your Gemfile, run `bundle install` from your terminal. This will install the listed gems for you. They won't show up in the directory, but they are in your system, and available.

Running `bundle install` also creates a new file: `Gemfile.lock`. This file notes which specific version of the gem was installed.


### config/environment.rb

When you start up an app, your app needs to know the order in which to load files. If your app uses gems, a lot of your code will depend on these external libraries. This means we'd want the gems to be loaded in our app _before_ our own code. If we loaded our code first, we'd get uninitialized constant errors or undefined variable or method errors. Load order matters. We can specify load information in `config/environment.rb` to configure our load path (or load order) so that nothing breaks.

Here we specify which Bundler groups we want to load. The following code is used to load the `default` group (anything not explicitly in a group, like `test` in your Gemfile) and the `development` group.

**Place the following code in `config/environment.rb`:**

```ruby
require 'bundler/setup'
Bundler.require(:default, :development)
```

In the example above, we're first requiring `'bundler/setup'`. If we don't do this, our app won't know to use bundler to install our gems. Without that line, our `Gemfile` becomes pointless.

**Important:** The two arguments that you are passing into the `.require` method *must be passed in the correct order, shown above*. The test you are trying to pass is testing for order.

### bin/run.rb

This is where the action is. This is where our app logic goes, and where we make our millions.

To take advantage of all of the work we did in the environment file, let's require it here.

**Place the following code in `bin/run.rb`:**

```ruby
require_relative '../config/environment'
```

That's it! Now we can access all of our gems from our `run.rb` file.

### require and require_relative 

You will notice that we use two different require methods while setting up our environment and bin files. 

While both of these methods might look similiar they do different things. Both load a file based on the filename passed in as a parameter and return true if the file was found and loaded successfully and they will raise a LoadError if it returns false. However... 

* [require](http://apidock.com/ruby/Kernel/require) takes an absolute path for the filename, so the file must either be in the directory from which the application is being run or in one of the directories in your shell's PATH variable (which often includes the directory containing the gems you've installed).

* [require_relative](http://apidock.com/ruby/Kernel/require_relative) takes a relative path that is relative to the file in which the require statement is called (so it's relative to the file being run, not to the directory from which the code is being called).


## Resources
* [RailsCasts](http://railscasts.com/) - [#201 Bundler (revised)](http://railscasts.com/episodes/201-bundler-revised)
* [Bundler Docs](http://bundler.io/docs.html) - [Bundler with Sinatra](http://bundler.io/v1.16/guides/sinatra.html)

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/using-bundler' title='Gems and Bundler'>Gems and Bundler</a> on Learn.co and start learning to code for free.</p>
