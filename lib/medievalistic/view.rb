require 'tilt'

module Medievalistic
  class View
    def initialize(options = {})
      options.each { |k,v| instance_variable_set("@#{k}", v) }
    end

    def render_content(doublemeat_medley, render_options)
      inner_content  = render_options.delete(:content) \
                    || content_from_template(render_options)
      content = wrap_content_in_layout(inner_content, render_options)
      doublemeat_medley.write_type_and_content(render_options[:content_type], content)
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
    # If Tilt whinges, just read the file contents and pass them back.
    def render_template(*args)
      options = args.extract_options!
      filename, content = *args
      begin
        layout = Tilt.new(filename)
        layout.render(nil, options) { content }
      rescue Exception => e
        raise e unless e.message.include?('No template engine registered for')
        @file_finder.read_file(filename)
      end
    end
  end
end
