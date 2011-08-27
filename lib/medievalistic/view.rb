require 'tilt'

module Medievalistic
  class View
    def initialize(doublemeat_medley)
      @doublemeat_medley = doublemeat_medley
    end

    def path_finder
      PathFinder.new(@doublemeat_medley)
    end
    
    def content_from_template(controller_name, action, options = {})
      format = options[:format] || :html
      base_name = '%s.%s' % [action, format]
      path_finder.template_file_for(controller_name, base_name)
    end
    
    def wrap_content_in_layout(content, options = {})
      layout = options[:layout] || 'default'
      layout_template = path_finder.layout_filename(layout) + '.html.erb'
      layout = Tilt.new(layout_template)
      layout.render() { content }
    end
  end
end
