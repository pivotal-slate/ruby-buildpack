$: << 'cf_spec'
require 'cf_spec_helper'

describe 'Rack App' do
  let(:browser) { Machete::Browser.new }
  let(:firewall_log) { Machete::FirewallLog.new }
  let(:focker) { Machete::Focker.new }

  before(:all) do # FIXME can this be reused?
    `docker rm cloudfocker-staging 2>&1`
    sleep 1
  end

  context 'in an offline environment' do
    before do
      Machete.use_offline_environment
    end

    specify do
      focker.deploy_app('./cf_spec/fixtures/sinatra_web_app')
      expect(focker).to have_successfully_deployed_app

      browser.visit('/')

      expect(firewall_log).to_not have_egress_attempts
    end
  end

  context 'in an online environment' do
    before do
      Machete.use_online_environment
    end

    specify do
      focker.deploy_app('./cf_spec/fixtures/sinatra_web_app')

      expect(focker).to have_successfully_deployed_app

      browser.visit('/')
      expect(browser).to have_body('Hello world!')

    end
  end
end
