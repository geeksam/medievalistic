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
      content = build_content(args.shift, options)
      actually_render content, options
    end

    def content_from_template(options = {})
      view.content_from_template(self.name, action, options)
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

    protected

    def build_content(content, options)
      content ||= content_from_template(options)
      view.wrap_content_in_layout(content, options)
    end

    def actually_render(content, options)
      raise DoubleRenderError if @already_rendered
      format = options[:format] || :html
      @doublemeat_medley.write_type_and_content(ContentTypes[format], content)
      @already_rendered = true
    end

  end
end
