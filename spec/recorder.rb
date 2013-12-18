require 'rack'

FIXTURES_DIR = File.expand_path('../../spec/fixtures/records', __FILE__)

class FixtureRecorder
  def initialize(app)
    @app = app
  end

  def call(env)
    env['fixture_file_path'] = File.join(FIXTURES_DIR, [env['PATH_INFO'].downcase.gsub('/', '_')[/[^_].+/], 'env'].join('.'))
    @app.call(env)
  ensure
    File.open(env['fixture_file_path'], 'w') do |file|
      file.write(Marshal.dump(env.merge({ 'rack.input' => env['rack.input'].read }).select { |key, value| Marshal.dump(value) rescue false }))
    end
  end
end

app = Rack::Builder.new do
  use FixtureRecorder
  run Proc.new { |env| [200, {}, StringIO.new(env['fixture_file_path'])] }
end

Rack::Handler::WEBrick.run app, Port: 4567
