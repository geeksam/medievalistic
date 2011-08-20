module Medievalistic
  class RoutingError < RuntimeError
  end

  class Router
    def call(env)
      request  = Rack::Request.new(env)
      response = Rack::Response.new

      controller_name, action_name, *_ = path_components(request.path_info)
      begin
        controller_class = load_controller_class(controller_name)
      rescue RoutingError => e
        raise e.class.new(e.message + " (path: '#{request.path_info}')")
      end

      response.finish
    end


    protected

    def path_components(path_info)
      path_info.gsub(/^\//, '').split('/')
    end

    def controller_class_name(controller_name)
      controller_name.gsub(/^(.)/) { |m| m[0].chr.upcase } + 'Controller'
    end

    def load_controller_class(controller_name)
      klass_name = controller_name.gsub(/^(.)/) { |m| m[0].chr.upcase } + 'Controller'
      Object.const_get(klass_name)
    rescue NameError
      raise RoutingError.new("Unknown controller class: #{klass_name}")
    end
  end
end
