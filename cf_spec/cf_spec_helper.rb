require 'bundler/setup'
require 'machete'
require 'rspec/retry'

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.mkdir_p('./log')
    Machete.logger = Machete::Logger.new('./log/integration.log')

    puts '--------> Caching dependencies into offline buildpack'
    `./bin/package offline --use-cache`

    puts '--------> Installing buildpack '
    Machete.install_packaged_buildpack('./ruby_buildpack*.zip')
    puts '--------> Done with setup'
  end
end
