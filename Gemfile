source 'https://rubygems.org'

if Gem::Version.new(Bundler::VERSION) < Gem::Version.new('1.5.0')
  abort "Redmine requires Bundler 1.5.0 or higher (you're using #{Bundler::VERSION}).\nPlease update with 'gem update bundler'."
end

gem "rails", "4.2.5.2"
gem "jquery-rails", "~> 3.1.4"
gem "coderay", "~> 1.1.0"
gem "builder", ">= 3.0.4"
gem "request_store", "1.0.5"
gem "mime-types", (RUBY_VERSION >= "2.0" ? "~> 3.0" : "~> 2.99")
gem "protected_attributes"
gem "actionpack-action_caching"
gem "actionpack-xml_parser"
gem "roadie-rails"

# Request at least nokogiri 1.6.7.2 because of security advisories
gem "nokogiri", ">= 1.6.7.2"

# Request at least rails-html-sanitizer 1.0.3 because of security advisories 
gem "rails-html-sanitizer", ">= 1.0.3"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :x64_mingw, :mswin, :jruby]
gem "rbpdf", "~> 1.19.0"


gem 'puma'

# Optional gem for LDAP authentication
group :ldap do
  gem "net-ldap", "~> 0.12.0"
end

# Optional gem for OpenID authentication
group :openid do
  gem "ruby-openid", "~> 2.3.0", :require => "openid"
  gem "rack-openid"
end

platforms :mri, :mingw, :x64_mingw do
  # Optional gem for exporting the gantt to a PNG file, not supported with jruby
  group :rmagick do
    gem "rmagick", ">= 2.14.0"
  end

  # Optional Markdown support, not for JRuby
  group :markdown do
    gem "redcarpet", "~> 3.3.2"
  end
end

platforms :jruby do
  # jruby-openssl is bundled with JRuby 1.7.0
  gem "jruby-openssl" if Object.const_defined?(:JRUBY_VERSION) && JRUBY_VERSION < '1.7.0'
  gem "activerecord-jdbc-adapter", "~> 1.3.2"
end

# Include database gems for the adapters found in the database
# configuration file
require 'erb'
require 'yaml'
database_file = File.join(File.dirname(__FILE__), "config/database.yml")
if File.exist?(database_file)
  database_config = YAML::load(ERB.new(IO.read(database_file)).result)
  adapters = database_config.values.map {|c| c['adapter']}.compact.uniq
  if adapters.any?
    adapters.each do |adapter|
      case adapter
      when 'mysql2'
        gem "mysql2", "~> 0.3.11", :platforms => [:mri, :mingw, :x64_mingw]
        gem "activerecord-jdbcmysql-adapter", :platforms => :jruby
      when 'mysql'
        gem "activerecord-jdbcmysql-adapter", :platforms => :jruby
      when /postgresql/
        gem "pg", "~> 0.18.1", :platforms => [:mri, :mingw, :x64_mingw]
        gem "activerecord-jdbcpostgresql-adapter", :platforms => :jruby
      when /sqlite3/
        gem "sqlite3", :platforms => [:mri, :mingw, :x64_mingw]
        gem "jdbc-sqlite3", ">= 3.8.10.1", :platforms => :jruby
        gem "activerecord-jdbcsqlite3-adapter", :platforms => :jruby
      when /sqlserver/
        gem "tiny_tds", "~> 0.6.2", :platforms => [:mri, :mingw, :x64_mingw]
        gem "activerecord-sqlserver-adapter", :platforms => [:mri, :mingw, :x64_mingw]
      else
        warn("Unknown database adapter `#{adapter}` found in config/database.yml, use Gemfile.local to load your own database gems")
      end
    end
  else
    warn("No adapter found in config/database.yml, please configure it first")
  end
else
  warn("Please configure your config/database.yml first")
end

group :development do
  gem 'capistrano', '~> 3'
  gem 'sshkit-sudo'
  # gem 'capistrano3-delayed-job', '~> 1.0'
  # cap tasks to manage puma application server
  #gem 'capistrano3-puma'#, require: false
  gem 'capistrano3-puma', github: "seuros/capistrano-puma"
  gem 'capistrano-rails',   '~> 1.1'
  gem 'capistrano-bundler', '~> 1.1'
  gem 'capistrano-rvm',   '~> 0.1'
  gem "capistrano-db-tasks"
  gem 'capistrano-upload-config'

  gem 'capistrano-faster-assets', '~> 1.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem "bullet"
  gem "lol_dba"

  gem "rdoc", ">= 2.4.2"
  gem "yard"
end

group :test do
  gem "minitest"
  gem "rails-dom-testing"
  gem "mocha"
  gem "simplecov", "~> 0.9.1", :require => false
  # For running UI tests
  gem "capybara"
  gem "selenium-webdriver"
end

local_gemfile = File.join(File.dirname(__FILE__), "Gemfile.local")
if File.exists?(local_gemfile)
  eval_gemfile local_gemfile
end

# Load plugins' Gemfiles
Dir.glob File.expand_path("../plugins/*/{Gemfile,PluginGemfile}", __FILE__) do |file|
  eval_gemfile file
end
