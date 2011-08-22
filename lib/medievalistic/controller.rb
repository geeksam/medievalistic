module Medievalistic
  class Controller
    ContentTypes = {
      :text => 'text/plain',
      :html => 'text/html',
    }
    class DoubleRenderError < Exception
    end

    def self.dispatch(doublemeat_medley, action)
      new(doublemeat_medley).send(action)
    end

    attr_reader :doublemeat_medley

    def initialize(doublemeat_medley)
      @doublemeat_medley = doublemeat_medley
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
        @doublemeat_medley.write_type_and_content(ContentTypes[type], options.delete(type))
      end
    end
  end
end
