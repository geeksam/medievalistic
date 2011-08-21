require 'forwardable'

module Medievalistic
  class App
    extend Forwardable

    def call(env)
      request  = Rack::Request.new(env)
      response = Rack::Response.new
      router.dispatch(request, response)
      response.finish
    end

    def router
      @router ||= Router.new
    end
  end
end
