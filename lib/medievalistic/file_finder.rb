module Medievalistic
  class FileFinder
    def initialize(root_path)
      @root_path = root_path
    end
    
    def layout_filename(layout)
      from_root('views', 'layouts', layout)
    end
    
    def template_filename(controller_name, base_name)
      from_root('views', controller_name, base_name)
    end
    
    def read_file(filename)
      File.open(filename, 'r').read
    end

    # Join components together and append them to the path.
    # Note:  Uses dir globbing to return an actual filename from the target dir.
    # So if you ask for 'foo.html' and 'foo.html.erb' is present, you'll get 'foo.html.erb'.
    # Behavior when multiple files match the given pattern is undefined.
    def from_root(*components)
      base_path = File.join(@root_path, *components.map(&:to_s))
      Dir[base_path + '*'].first
    end
  end
end
