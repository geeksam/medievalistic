module Medievalistic
  class RoutingError < RuntimeError
  end

  class Router
    attr_reader :app
    def initialize(app)
      @app = app
    end

    def dispatch(request)
      controller_class, action = controller_class_and_action(request.path)
      controller_class.dispatch(request, action)
    end

    def controller_class_and_action(path)
      controller_name, action = path_components(path)
      controller_name = controller_name.gsub(/^(.)/) { |m| m[0].chr.upcase } + 'Controller'
      controller_class = Object.const_get(controller_name)
      [controller_class, action.to_sym]
    end

    def path_components(path)
      components = path.gsub(/^\//, '').split('/')
      components[0] ||= 'home'
      components[1] ||= 'index'
      components[0..1]
    end
  end
end
