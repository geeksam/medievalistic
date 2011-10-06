require 'tilt'

module Medievalistic
  class View
    def initialize(options = {})
      options.each { |k,v| instance_variable_set("@#{k}", v) }
    end

    def render_content(render_options)
      inner_content  = render_options.delete(:content) \
                    || content_from_template(render_options)
      content = wrap_content_in_layout(inner_content, render_options)
      @doublemeat_medley.write_type_and_content(render_options[:content_type], content)
    end

    protected

    def content_from_template(render_options = {})
      template_filename = @file_finder.template_filename(@controller_name, @controller_action, render_options[:format] || :html)
      render_template(template_filename, render_options)
    end

    def wrap_content_in_layout(content, render_options = {})
      layout_filename = @file_finder.layout_filename(render_options[:layout] || :default)
      render_template(layout_filename, content, render_options)
    end

    # Attempt to render the template using Tilt.
    # If that doesn't work, treat it as a static template.
    def render_template(*args)
      options = args.extract_options!
      filename, content = *args
      render_tilt(filename, content, options) || render_static(filename)
    end

    def render_tilt(filename, content, options)
      # First arg to Tilt#render is an object to use as a binding.
      # I leave this nil because I think using instance variables is a horrible misfeature of Rails.
      Tilt.new(filename).render(nil, options) { content } rescue nil
    end

    def render_static(filename)
      File.open(filename, 'r').read
    end
  end
end
