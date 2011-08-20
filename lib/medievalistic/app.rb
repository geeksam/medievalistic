class Medievalistic::App
  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new
    response.finish
  end
end
