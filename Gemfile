# Gemfile - A format for describing gem dependencies for Ruby programs

# Gemfile manual :
#  http://bundler.io/v1.3/man/gemfile.5.html

# How to write Gemfile for bundler
#  http://bundler.io/v1.3/gemfile.html

# GemFile need at least 1 Gem source
source 'https://rubygems.org'

# Gems and their version depended
# e.g.:
#  gem 'rake'                   # latest version of gem rake
#  gem 'rails', "3.0.0.beta3"   # very specified version of rails
#  gem 'rack', ">=1.0"          # versions >=1.0
#  gem 'thin', "~>1.1"          # versions >=1.1 and < 2.0
#  gem 'some_gem',"~>1.0.3"     # versions >=1.0.3 and < 1.1
gem 'rspec', '~> 2.13'
gem 'rake'
gem 'ci_reporter'
gem 'cfoundry', '~> 4.0.4.rc2'
gem 'cf-uaa-lib'
gem 'httparty'
gem 'blue-shell'
gem 'parallel_tests'

# group: http://bundler.io/v1.3/groups.html
# used for 'bundle install --without ${group_name}'
#       or 'bundle install --require ${group_name}'
group :monitoring do
  gem 'dogapi'
end
