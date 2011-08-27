module Medievalistic
  class PathFinder
    def initialize(doublemeat_medley)
      @doublemeat_medley = doublemeat_medley
    end
    
    def layout_filename(layout)
      from_root('views', 'layouts', layout)
    end
    
    def template_filename_for(controller_name, base_name)
      base_name = from_root('views', controller_name, base_name)
      # TODO: glob for, e.g., foo.html.erb
      base_name
    end
    
    def template_file_for(controller_name, base_name)
      File.open(template_filename_for(controller_name, base_name), 'r').read
    end

    def from_root(*components)
      base_path = File.join(@doublemeat_medley.root_path, *components.map(&:to_s))
    end
  end
end
