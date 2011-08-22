require 'forwardable'

module Medievalistic
  class App
    extend Forwardable

    def call(env)
      request = Request.new(self, env)
      router.dispatch(request.rack_request, request.rack_response)
      request.rack_response.finish
    end

    def router
      @router ||= Router.new(self)
    end
  end
end
