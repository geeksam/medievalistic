module Medievalistic
  class FileFinder
    attr_reader :root_path

    def initialize(root_path)
      @root_path = root_path
    end

    def layout_filename(layout)
      from_root('views', 'layouts', layout)
    end

    def template_filename(controller, action, format)
      filename = [action, format].compact.join('.')
      from_root('views', controller, filename)
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
