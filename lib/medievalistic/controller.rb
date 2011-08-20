module Medievalistic
  class Controller
    ContentTypes = {
      :text => 'text/plain',
      :html => 'text/html',
    }
    class DoubleRenderError < Exception
    end

    attr_reader :request, :response

    def initialize(request, response)
      @request, @response = request, response
    end

    def render(*args)
      options = args.extract_options!
      ContentTypes.keys.each do |type|
        try_rendering(options, type)
      end
    end

    def rendered?
      !! @rendered_eh
    end

    protected
    def try_rendering(options, type)
      return unless options.has_key?(type)
      raise DoubleRenderError if rendered?

      @rendered_eh = true
      content, content_type = options.delete(type), ContentTypes[type]

      response["Content-Type"] = content_type
      response.write content
    end
  end
end
