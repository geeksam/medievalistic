module Medievalistic
  class Router
    def call(env)
      # request  = Rack::Request.new(env)  # You ARE gonna need it... but you don't yet.
      response = Rack::Response.new

      # ...

      response.finish
    end
  end
end
