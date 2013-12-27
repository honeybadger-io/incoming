require 'rack'

FIXTURES_DIR = File.expand_path('../../spec/fixtures', __FILE__)

class FixtureRecorder
  def initialize(app)
    @app = app
  end

  def call(env)
    env['fixture_file_path'] = file_path_from(env)
    begin
      @app.call(env)
    ensure
      File.open(env['fixture_file_path'], 'w') do |file|
        file.write(dump_env(env))
      end
    end
  end

  def file_path_from(env)
    file_path = env['PATH_INFO'].downcase.gsub('/', '_')[/[^_].+[^_]/]
    file_path = 'root' unless file_path =~ /\S/
    File.join(FIXTURES_DIR, [file_path, 'env'].join('.'))
  end

  def dump_env(env)
    safe_env = env.dup
    safe_env.merge!({ 'rack.input' => env['rack.input'].read })
    safe_env = safe_env.select { |_,v| Marshal.dump(v) rescue false }
    Marshal.dump(safe_env)
  end
end

app = Rack::Builder.new do
  use FixtureRecorder
  run Proc.new { |env|
    [200, {}, StringIO.new(env['fixture_file_path'])]
  }
end

Rack::Handler::WEBrick.run app, Port: 4567
