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
      options[:content] = args.shift
      actually_render(options)
    end

    def name
      self.class.
        name.
        gsub(/Controller$/, '').
        gsub(/(.)([A-Z])/) { |match| match[1] + '_' + match[2] }.
        downcase
    end

    protected

    def view
      @view ||= View.new({
        :file_finder       => @file_finder,
        :controller_name   => name,
        :controller_action => action,
      })
    end

    def actually_render(options)
      raise DoubleRenderError if @already_rendered
      @already_rendered = true
      options[:content_type] = ContentTypes[options[:format] || :html]
      view.render_content(@doublemeat_medley, options)
    end
  end
end
