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

    def render(content)
raise 'wtf?' if content.is_a?(Hash)
      render_as(:html, content)
    end

    def render_as(format, content)
      raise DoubleRenderError if @already_rendered
      @already_rendered = true
      @doublemeat_medley.write_type_and_content(ContentTypes[format], content)
    end

  end
end
