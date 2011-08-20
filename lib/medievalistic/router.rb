module Medievalistic
  class RoutingError < RuntimeError
  end

  class Router
    def call(env)
      request  = Rack::Request.new(env)
      response = Rack::Response.new

      controller_class, action = route(request.path_info)

      controller = controller_class.new(request, response)
      controller.send(action)

      response.finish
    end

    def route(path)
      controller_name, action_name, *_ = path_components(path)
      controller_class = load_controller_class(controller_name, path)
      [controller_class, action_name]
    end

    protected

    def path_components(path_info)
      components = path_info.gsub(/^\//, '').split('/')
      case components.length
      when 1 then components << 'index'
      end
      components
    end

    def controller_class_name(controller_name)
      controller_name.gsub(/^(.)/) { |m| m[0].chr.upcase } + 'Controller'
    end

    def load_controller_class(controller_name, path)
      klass_name = controller_name.gsub(/^(.)/) { |m| m[0].chr.upcase } + 'Controller'
      Object.const_get(klass_name)
    rescue NameError
      raise RoutingError.new("Unknown controller class: #{klass_name} (path: '#{path}')")
    end
  end
end
