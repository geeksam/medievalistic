require 'forwardable'

module Medievalistic
  class DoublemeatMedley
    attr_reader :app, :rack_request, :rack_response
    
    def initialize(app, env)
      @app = app
      @rack_request  = Rack::Request.new(env)
      @rack_response = Rack::Response.new
    end

    extend Forwardable
    def_delegator :rack_request, :path_info, :path
    def_delegator :rack_response, :finish, :finalize

    def write_type_and_content(content_type, content)
      rack_response["Content-Type"] = content_type
      rack_response.write content
    end
  end
end
