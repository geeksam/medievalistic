module Medievalistic
  class Controller
    ContentTypes = {
      :text => 'text/plain',
      :html => 'text/html',
    }
    class DoubleRenderError < Exception
    end

    def self.dispatch(doublemeat_medley, action)
      new(doublemeat_medley).dispatch(action)
    end

    attr_reader :doublemeat_medley, :action

    def initialize(doublemeat_medley)
      @doublemeat_medley = doublemeat_medley
      @already_rendered = false
    end

    def dispatch(action)
      send @action = action
    end

    def render(content = nil)
      case content
      when nil
        render_template :html
      when String
        render_as(:html, content)
      end
    end

    def render_as(format, content)
      raise DoubleRenderError if @already_rendered
      @already_rendered = true
      @doublemeat_medley.write_type_and_content(ContentTypes[format], content)
    end

    def render_template(format)
      base_name = '%s.%s' % [action, format]
      template_filename = template_path(base_name)
      content = File.open(template_filename, 'r').read
      render_as format, content
    end

    def template_path(*additional_paths)
      File.expand_path(File.join(doublemeat_medley.root_path, 'views', controller_name, *additional_paths))
    end

    def controller_name
      self.class.
        name.
        gsub(/Controller$/, '').
        gsub(/(.)([A-Z])/) { |match| match[1] + '_' + match[2] }.
        downcase
    end
  end
end
