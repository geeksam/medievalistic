require 'tilt'

module Medievalistic
  class View
    def initialize(options = {})
      options.each { |k,v| instance_variable_set("@#{k}", v) }
    end

    def render_content(doublemeat_medley, options)
      content = options.delete(:content) \
                || content_from_template(@controller_name, @controller_action, options)
      content_in_layout = wrap_content_in_layout(content, options)
      doublemeat_medley.write_type_and_content(options[:content_type], content_in_layout)
    end

    protected

    def content_from_template(controller_name, action, options = {})
      format = options[:format] || :html
      base_name = [action, format].join('.')
      view_template = @file_finder.template_filename(controller_name, base_name)
      render_template(view_template, nil, options)
    end

    def wrap_content_in_layout(content, options = {})
      layout_template = @file_finder.layout_filename(options[:layout] || :default)
      render_template(layout_template, content, options)
    end

    # Attempt to render the template using Tilt.
    # If Tilt whinges, just read the file contents and pass them back.
    def render_template(filename, content, options = {})
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
