module Medievalistic
  class RoutingError < RuntimeError
  end

  module Router
    module_function

    def dispatch(doublemeat_medley, file_finder)
      controller_class, action = controller_class_and_action(doublemeat_medley.request_path, file_finder)
      controller_class.dispatch(doublemeat_medley, file_finder, action)
    end

    def controller_class_and_action(path, file_finder)
      controller_name, action = path_components(path)
      controller_class = get_controller_class(controller_name, file_finder)
      [controller_class, action.to_sym]
    end

    def path_components(path)
      components = path.gsub(/^\//, '').split('/')
      components[0] ||= 'home'
      components[1] ||= 'index'
      components[0..1]
    end

    def get_controller_class(controller_name, file_finder)
      controller_class_name = controller_name.gsub(/^(.)/) { |m| m[0].chr.upcase } + 'Controller'
      begin
        Object.const_get(controller_class_name)
      rescue NameError => name_error
        begin
          require file_finder.from_root('controllers', controller_name + '_controller')
        rescue LoadError
          raise name_error
        end
        Object.const_get(controller_class_name)
      end
    end
  end
end
