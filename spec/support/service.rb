require "support/test_env"

module ServiceHelper

  # self.included( base ) 'Progmatic programming Ruby 1.9 and 2.0 4th edition P390'
  # called when we include 'ServiceHelper' module in a class ('base' here), the included hook method gets invoked
  def self.included(base)
    base.instance_eval do
      # instance_eval :
      #    evaluates code_string / block withing context of receiver('base' here)
      #    must be called by instance (unlike class_eval, must be called by class)

      # let() : cache on 1st invoke; return cached value on following invoke
      let(:namespace) { nil }
      let(:instance_name) { "#{app_name}_service_instance" }   #execute app_name, put the result in string
      let(:host) { "services-nyets-#{app_name}" }

      # user_with_org.rb
      with_user_with_org   # get let() including : :admin_user, :regular_user, :org (some are from ENV())
      with_shared_space    # get let() including : :space

      let(:dog_tags) { {service: app_name} }    # :dog_tags = { :service => app_name }
      let(:test_app_path) { File.join(File.dirname(__FILE__), "../../apps/ruby/app_sinatra_service") }

      # sinatra : DSL for quickly creating web applications in Ruby with minimal effort
      #   http://www.sinatrarb.com/
      #   http://www.sinatrarb.com/documentation.html
      #   book 'Sinatra tip and running'
      #   gem install sinatra

      # executed before every scenario
      before do
        regular_user.clean_up_app_from_previous_run(app_name)
        regular_user.clean_up_service_instance_from_previous_run(space, instance_name)
        regular_user.clean_up_route_from_previous_run(host)

        @app_signature = SecureRandom.uuid
        @app = regular_user.create_app(space, app_name, {APP_SIGNATURE: @app_signature})
        @route = regular_user.create_route(@app, host, TestEnv.default.apps_domain)
      end

      # executed after every scenario
      after do
        regular_user.clean_up_app_from_previous_run(app_name)
        regular_user.clean_up_service_instance_from_previous_run(space, instance_name)
        regular_user.clean_up_route_from_previous_run(host)
      end

      # /what?/ what is scenario ?

    end
  end

  def create_and_use_managed_service(&blk)
    service_instance = nil
    monitoring.record_action("create_service", dog_tags) do
      service_instance = regular_user.create_managed_service_instance(space, service_name, plan_name, instance_name)
      service_instance.guid.should be
    end

    use_managed_service(service_instance, &blk)

    rescue CFoundry::APIError => e
      monitoring.record_metric("services.health", 0, dog_tags)
      puts '--- CC error:'
      puts '<<<'
      puts e.request_trace
      puts '>>>'
      puts e.response_trace
      raise
    rescue RSpec::Core::Pending::PendingDeclaredInExample => e
      raise e
    rescue => e
      monitoring.record_metric("services.health", 0, dog_tags)
      raise e
  end

  def use_managed_service_instance(guid, &block)
    service_instance = regular_user.find_service_instance(guid)
    use_managed_service(service_instance, &block)
  end

  def use_managed_service(service_instance, &blk)
    monitoring.record_action("bind_service", dog_tags) do
      binding = regular_user.bind_service_to_app(service_instance, @app)
      binding.guid.should be
    end

    test_app = nil

    begin
      @app.upload(File.expand_path(test_app_path, __FILE__))
      monitoring.record_action(:start, dog_tags) do
        @app.start!
        test_app = TestApp.new(
          app: @app,
          host_name: @route.name,
          service_instance: service_instance,
          namespace: namespace,
          example: self,
          signature: @app_signature
        )
        test_app.wait_until_running
      end
    rescue => e
      raise if ENV["NYET_RAISE_ALL_ERRORS"]
      pending "Unable to push an app. Possibly backend issue, error #{e.inspect}"
    end

    blk.call(test_app)

    monitoring.record_metric("services.health", 1, dog_tags)

    rescue CFoundry::APIError => e
      monitoring.record_metric("services.health", 0, dog_tags)
      puts '--- CC error:'
      puts '<<<'
      puts e.request_trace
      puts '>>>'
      puts e.response_trace
      raise
    rescue RSpec::Core::Pending::PendingDeclaredInExample => e
      raise e
    rescue => e
      monitoring.record_metric("services.health", 0, dog_tags)
      raise e
    end
end

RSpec.configure do |config|
  config.include(ServiceHelper, :service => true)
end
