describe "Bundler" do
  describe "Gemfile" do
    before :all do
      @gemfile_text = File.read('Gemfile')
    end

    # http://bundler.io/v1.3/gemfile.html
    it "should specify rubygems as a source using the SSL protocol" do
      (@gemfile_text =~ /source .https:\/\/rubygems.org./).should_not == nil
    end

    # http://bundler.io/v1.3/gemfile.html
    it "should list the hashie gem without specifying a version" do
      (@gemfile_text =~ /gem .hashie./).should_not == nil
    end

    # http://bundler.io/v1.3/gemfile.html
    it "should list the sinatra gem with the specific version 1.4.4" do
      (@gemfile_text =~ /gem .sinatra., .v?1\.4\.4./).should_not == nil
    end

    # http://robots.thoughtbot.com/post/2508037841/rubys-pessimistic-operator
    it "should list the octokit gem specifying version 2.0 with a twiddle-wakka" do
      (@gemfile_text =~ /gem .octokit.*.~> 2\.0./).should_not == nil
    end


    describe "groups" do
      before :each do
        `bundle --without nothing`
      end

      # http://bundler.io/v1.3/groups.html
      # Use the updated Hash syntax { foo: bar }
      it "should contain the pry gem in the development group using a hash argument to the gem method" do
        (@gemfile_text =~ /gem .pry., group: :development'?/).should_not == nil

        bundle_output = `bundle`
        (bundle_output =~ /pry/).should_not == nil

        bundle_output = `bundle --without development`
        (bundle_output =~ /pry/).should == nil
      end

      # http://bundler.io/v1.3/groups.html
      # Use the updated Hash syntax { foo: bar }
      it "should contain the rspec gem in the test group using block syntax" do
        (@gemfile_text =~ /group .?test.* do/).should_not == nil

        bundle_output = `bundle`
        (bundle_output =~ /rspec/).should_not == nil

        bundle_output = `bundle --without test`
        (bundle_output =~ /rspec/).should == nil
      end
    end
  end

  # manually run bundle install to get this passing
  # (or bundle for short)
  describe "bundle install" do
    describe "Gemfile.lock" do
      it "should exist after running `bundle install`" do
        File.exists?('Gemfile.lock').should == true
      end
    end
  end

  describe "integration" do
    before :each do
      @environment_text = File.read('config/environment.rb')
    end

    # http://bundler.io/
    it "should require bundler/setup in the environment" do
      (@environment_text =~ /require .bundler\/setup./).should_not == nil
    end

    # http://bundler.io/v1.3/groups.html
    it "should require the default and development groups" do
      (@environment_text =~ /Bundler\.require\(:default, :development\)/).should_not == nil
    end

    it "should successfully make the bundler gems available in bin/run.rb" do
      expect { require_relative "../bin/run.rb" }.not_to raise_error
    end
  end
end
