module Medievalistic
  class Controller
    ContentTypes = {
      :text => 'text/plain',
      :html => 'text/html',
    }
    class DoubleRenderError < Exception
    end

    attr_reader :action

    def initialize(doublemeat_medley, file_finder)
      @doublemeat_medley = doublemeat_medley
      @file_finder = file_finder
      @already_rendered = false
    end

    def self.dispatch(doublemeat_medley, file_finder, action)
      new(doublemeat_medley, file_finder).dispatch(action)
    end

    def dispatch(action)
      @action = action
      self.send action
    end

    def render(*args)
      options = args.extract_options!
      maybe_content = args.shift
      content = build_content(maybe_content, options)
      actually_render content, options
    end

    def view
      @view ||= View.new(@file_finder)
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
      content ||= view.content_from_template(name, action, options)
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
