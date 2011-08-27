require 'tilt'

module Medievalistic
  class View
    def initialize(doublemeat_medley)
      @doublemeat_medley = doublemeat_medley
      @path_finder = PathFinder.new(@doublemeat_medley)
    end

    def content_from_template(controller_name, action, options = {})
      format = options[:format] || :html
      base_name = [action, format].join('.')
      view_template = @path_finder.template_filename_for(controller_name, base_name)
      render_template(view_template, nil, options)
    end
    
    def wrap_content_in_layout(content, options = {})
      layout = options[:layout] || :default
      layout_template = @path_finder.layout_filename(layout)
      render_template(layout_template, content, options)
    end

    def render_template(filename, content, options = {})
      begin
        layout = Tilt.new(filename)
        layout.render(nil, options) { content }
      rescue Exception => e
        raise e unless e.message.include?('No template engine registered for')
        @path_finder.read_file(filename)
      end
    end
  end
end
