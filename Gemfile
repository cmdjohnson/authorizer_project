source :gemcutter
gem "rails", "= 2.3.12"

# bundler requires these gems in all environments
################################################################################
# basic gems from the 2_3_11 project template
################################################################################
gem "haml", "3.0.18"
gem "dry_scaffold", "~> 0.3.8"
gem "will_paginate", "2.3.14"
gem "formtastic", "1.1.0"
gem "factory_girl", "1.3.2"
gem "rdoc", "3.8"
################################################################################

################################################################################
# Dependencies for Heroku so there can be no question what gem version to use
# Using other versions might cause small annoyances such as wrong I18n strings etc.
################################################################################
gem "json", "1.4.6"
gem "i18n", "0.4.2"
gem "inherited_resources", "1.0.6"
################################################################################

################################################################################
# gems added for project
################################################################################
gem "authlogic", "2.1.6"
################################################################################

################################################################################
# What it's all about
################################################################################
gem "options_checker", "0.0.1"
#gem "authorizer", "0.0.1" # use plugin for now
################################################################################

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
  gem "sqlite3-ruby", :require => "sqlite3"
  gem "mongrel"
end

group :test do
  # bundler requires these gems while running tests
  # gem "rspec"
  # gem "faker"
  #gem "firewatir"
  # This gives us nice green/yellow/red output from tests in console
  gem "test-unit", "2.1.1"
  #gem "rcov", "0.9.9"
  #gem "ruby-prof", "0.9.2"
end

