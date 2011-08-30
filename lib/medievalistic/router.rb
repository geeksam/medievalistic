module Medievalistic
  class RoutingError < RuntimeError
  end

  class Router
    def initialize(file_finder)
      @file_finder = file_finder
    end

    def dispatch(doublemeat_medley)
      controller_class, action = controller_class_and_action(doublemeat_medley.request_path)
      controller_class.dispatch(doublemeat_medley, action)
    end

    def controller_class_and_action(path)
      controller_name, action = path_components(path)
      controller_class = get_controller_class(controller_name)
      [controller_class, action.to_sym]
    end

    def get_controller_class(controller_name)
      controller_class_name = controller_name.gsub(/^(.)/) { |m| m[0].chr.upcase } + 'Controller'
      begin
        Object.const_get(controller_class_name)
      rescue NameError => name_error
        begin
          require @file_finder.from_root('controllers', controller_name + '_controller')
        rescue LoadError
          raise name_error
        end
        Object.const_get(controller_class_name)
      end
    end

    def path_components(path)
      components = path.gsub(/^\//, '').split('/')
      components[0] ||= 'home'
      components[1] ||= 'index'
      components[0..1]
    end
  end
end
