module Medievalistic
  class Controller
    ContentTypes = {
      :text => 'text/plain',
      :html => 'text/html',
    }
    class DoubleRenderError < Exception
    end

    attr_reader :request, :response

    def self.dispatch(app, request, response, action)
      instance = new(app, request, response)
      instance.send(action)
    end

    def initialize(app, request, response)
      @app, @request, @response = app, request, response
      @already_rendered = false
    end

    def render(*args)
      options = args.extract_options!
      case
      when (ContentTypes.keys & options.keys).present?
        try_rendering_format_value(options)
      end
    end

    protected
    def try_rendering_format_value(options)
      (ContentTypes.keys & options.keys).each do |type|
        next unless options.has_key?(type)
        content = options.delete(type)
        write_type_and_content(ContentTypes[type], content)
      end
    end

    def write_type_and_content(content_type, content)
      raise DoubleRenderError if @already_rendered
      @already_rendered = true
      response["Content-Type"] = content_type
      response.write content
    end
  end
end
