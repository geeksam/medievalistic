require 'forwardable'

module Medievalistic
  class Request
    attr_reader :app, :rack_request, :rack_response
    
    def initialize(app, env)
      @app = app
      @rack_request  = Rack::Request.new(env)
      @rack_response = Rack::Response.new
    end
  end
end
