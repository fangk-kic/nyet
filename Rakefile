require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'     # use this if you're using RSpec


# RSpec : testing tool for Ruby
#         http://rspec.info
#         gem install rspec
#         rspec --help
#         documents :
#             http://rubydoc.info/gems/rspec-core
#             http://rubydoc.info/gems/rspec-expectations
#             http://rubydoc.info/gems/rspec-mocks
#             http://rubydoc.info/gems/rspec-rails
#         book : “The RSpec Book”


# RAKE  : Ruby Make + Automation tool
#         http://rake.rubyforge.org/
#         gem install rake
#         rake -help
#         invoke rake : system search for RakeFile in ".", "..", "../../", ... until RakeFile is found
#                       rake               # will invoke task specified by "task :default"
#                       rake ${task_name}  # will invoke "${task_name}"
#         list all tasks : rake -T


# call function 'RakeTask#new' which 'yield' a RakeTask object /c/
# /c/ is passed to code block
RSpec::Core::RakeTask.new(:spec) do |c|
  # rspec_opts: command line options to pass to rspec
  # --format documentation --color : output to document with color
  # to get argument : rspec --help
  c.rspec_opts = %w(--format documentation --color)
end

# run spec as default rake task : http://blog.revathskumar.com/2011/12/run-rspec-as-rake-task.html
task :default => :spec

# in :spec namespace
namespace :spec do

  # rake -T
  #   rake spec
  #   rake spec:appdirect_services
  #   rake spec:managing_a_service
  #   rake spec:user_provided_service

  # create a rake_task, execute services_spec/**/*_spec.rb, with options of documentation,color, -tag appdirect
  RSpec::Core::RakeTask.new(:appdirect_services) do |c|
    c.pattern = 'services_spec/**/*_spec.rb'
    c.rspec_opts = %w(--format documentation --color --tag appdirect)
  end

  # create a rake_task, execute services_spec/managing_a_service_spec.rb, with options of documentation, color
  RSpec::Core::RakeTask.new(:managing_a_service) do |c|
    c.pattern = 'services_spec/managing_a_service_spec.rb'   # /why?/ run this task again
    c.rspec_opts = %w(--format documentation --color)
  end

  # create a rake_task, execute service_connector_spec.rb, with options of format, color
  RSpec::Core::RakeTask.new(:user_provided_service) do |c|
    c.pattern = 'services_spec/service_connector_spec.rb'    # /why?/ run this task seperately
    c.rspec_opts = %w(--format documentation --color)
  end

  # /guess/ invoking levels
  # Rakefile -> services_spec/**/*_spec.rb -> spec/**/*.rb

  # /why?/ define an empty task ??????
  task :service_connector

end
