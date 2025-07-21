require 'bundler/setup'
begin
  Bundler.require(:default, :development)
rescue LoadError, Bundler::GemRequireError
  require 'hashie'
  begin
    require 'pry'
  rescue LoadError
  end
end
