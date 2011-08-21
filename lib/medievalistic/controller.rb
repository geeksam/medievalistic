module Medievalistic
  class Controller
    ContentTypes = {
      :text => 'text/plain',
      :html => 'text/html',
    }
    class DoubleRenderError < Exception
    end

    attr_reader :request, :response

    def self.dispatch(request, response, action)
      instance = new(request, response)
      instance.send(action)
    end

    def initialize(request, response)
      # Actually hang on to the request and response at this point, because
      # typing "def show(request, response)" all the time would suck.
      @request, @response = request, response
      @rendered = false
    end

    def render(*args)
      options = args.extract_options!
      ContentTypes.keys.each do |type|
        try_rendering(options, type)
      end
    end

    protected
    def try_rendering(options, type)
      return unless options.has_key?(type)
      raise DoubleRenderError if @rendered

      @rendered = true

      response["Content-Type"] = ContentTypes[type]
      content = options.delete(type)
      response.write content
    end
  end
end
