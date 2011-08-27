module Medievalistic
  class Controller
    ContentTypes = {
      :text => 'text/plain',
      :html => 'text/html',
    }
    class DoubleRenderError < Exception
    end

    attr_reader :doublemeat_medley, :action

    def initialize(doublemeat_medley)
      @doublemeat_medley = doublemeat_medley
      @path_finder = PathFinder.new(doublemeat_medley)
      @already_rendered = false
    end

    def self.dispatch(doublemeat_medley, action)
      new(doublemeat_medley).dispatch(action)
    end

    def dispatch(action)
      @action = action
      self.send action
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
      options[:format] ||= :html
      content = view.content_from_template(self.name, action, options[:format])
      actually_render content, options
    end

    def actually_render(content, options)
      raise DoubleRenderError if @already_rendered

      format = options[:format] || :html
      layout = options[:layout] || 'default'

      body = view.wrap_content_in_layout(content, layout)

      @doublemeat_medley.write_type_and_content(ContentTypes[format], body)
      @already_rendered = true
    end

    def view
      @view ||= View.new(@doublemeat_medley)
    end

    def name
      self.class.
        name.
        gsub(/Controller$/, '').
        gsub(/(.)([A-Z])/) { |match| match[1] + '_' + match[2] }.
        downcase
    end
  end
end
