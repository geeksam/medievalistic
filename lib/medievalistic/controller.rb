module Medievalistic
  class Controller
    ContentTypes = {
      :text => 'text/plain',
      :html => 'text/html',
    }
    class DoubleRenderError < Exception
    end

    def self.dispatch(request, action)
      new(request).send(action)
    end

    attr_reader :request

    def initialize(request)
      @request = request
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
        raise DoubleRenderError if @already_rendered
        @already_rendered = true
        @request.write_type_and_content(ContentTypes[type], options.delete(type))
      end
    end
  end
end
