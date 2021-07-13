describe "Bundler" do

  describe "Gemfile" do
    let(:gemfile_text) { File.read('Gemfile') }
    let(:bundle_output) do
      Bundler.with_unbundled_env do
        `bundle`
      end
    end

    it "has correct syntax" do
      expect(bundle_output).not_to include("There was an error parsing")
    end

    # http://bundler.io/v1.3/gemfile.html
    it "specifies rubygems as a source using the SSL protocol on the first line" do
      expect(gemfile_text =~ /source ['"]https:\/\/rubygems\.org['"]/).not_to eq(nil)
    end

    # http://bundler.io/v1.3/gemfile.html
    it "lists the hashie gem without specifying a version" do
      expect(gemfile_text =~ /gem ['"]hashie['"]/).not_to eq(nil)
    end

    # http://bundler.io/v1.3/gemfile.html
    it "lists the sinatra gem with the specific version 2.0.2" do
      expect(gemfile_text =~ /gem ['"]sinatra['"], ?['"]v?2\.0\.2['"]/).not_to eq(nil)
    end

    # http://robots.thoughtbot.com/post/2508037841/rubys-pessimistic-operator
    it "lists the octokit gem specifying version 2.0 with a twiddle-wakka" do
      expect(gemfile_text =~ /gem ['"]octokit['"], ?['"]~> ?2\.0['"]/).not_to eq(nil)
    end

    # http://bundler.io/git.html
    it "lists the awesome_print gem specifying a remote git repository using the SSH URL (use github)" do
      expect(gemfile_text =~ /gem ['"]awesome_print['"], ?(git:|:git ?=>) ?['"]git@github\.com:awesome\-print\/awesome_print\.git['"]/).not_to eq(nil)
    end

    describe "groups" do
      after do
        system("rm .bundle/config")
      end

      # http://bundler.io/v1.3/groups.html
      it "contains the pry gem in the development group using a hash argument to the gem method" do
        expect(gemfile_text).to  match(/gem ['"]pry['"], ?(group:|:group ?=>) ?(:development|['"]development['"])/) | match(/group ?(:development|['"]development['"])[\s\S]*gem ['"]pry['"][\s\S]*end/)
        expect(bundle_output =~ /pry/).not_to eq(nil)

        bundle_output_without_development = ""
        Bundler.with_unbundled_env do
          bundle_output_without_development = `bundle config set --local without development`
        end
        expect(bundle_output_without_development =~ /pry/).to eq(nil)
      end

      # http://bundler.io/v1.3/groups.html
      it "contains the rspec gem in the test group using block syntax" do
        expect(gemfile_text =~ /group (:test|['"]test['"]) do/).not_to eq(nil)
        expect(bundle_output =~ /rspec/).not_to eq(nil)

        bundle_output_without_test = ""
        Bundler.with_unbundled_env do
          bundle_output_without_test = `bundle config set --local without test`
        end
        expect(bundle_output_without_test =~ /rspec/).to eq(nil)
      end
    end
  end

  # This may exist from having run bundle install in other tests
  describe "bundle install" do
    describe "Gemfile.lock" do
      it "exists after running `bundle install`" do
        expect(File.exists?('Gemfile.lock')).to eq(true)
      end
    end
  end

  describe "integration" do
    let(:environment_text) { File.read('config/environment.rb') }

    # http://bundler.io/
    it "requires bundler/setup in the environment" do
      expect(environment_text =~ /require ['"]bundler\/setup['"]/).not_to eq(nil)
    end

    # http://bundler.io/v1.3/groups.html
    it "requires the default and development groups in the environment" do
      expect(environment_text =~ /Bundler\.require\(:default, :development\)/).not_to eq(nil)
    end

    it "makes the bundler gems available in bin/run" do
      expect { load "bin/run" }.not_to raise_error
    end
  end
end
