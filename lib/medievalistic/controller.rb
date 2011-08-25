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

    def render(*args)
      options = args.extract_options!
      content = args.shift

      case content
      when nil
        render_template options
      when String
        actually_render content, options
      end
    end

    def render_template(options = {})
      format = options[:format] || :html

      content = File.open(template_filename_for(action, format), 'r').read

      actually_render content, options
    end

    def actually_render(body, options)
      format = options[:format] || :html

      raise DoubleRenderError if @already_rendered
      @already_rendered = true

      @doublemeat_medley.write_type_and_content(ContentTypes[format], body)
    end

    def layout_path(*additional_paths)
      File.expand_path(File.join(doublemeat_medley.root_path, 'views', 'layouts', *additional_paths))
    end

    def controller_name
      self.class.
        name.
        gsub(/Controller$/, '').
        gsub(/(.)([A-Z])/) { |match| match[1] + '_' + match[2] }.
        downcase
    end

    def template_filename_for(action, format)
      base_name = '%s.%s' % [action, format]
      base_name = File.expand_path(File.join(doublemeat_medley.root_path, 'views', controller_name, base_name))
      # TODO: glob for, e.g., foo.html.erb
      base_name
    end
  end
end
