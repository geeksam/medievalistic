require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. test_helper]))


class HelloController < Medievalistic::Controller
end

describe Medievalistic::Router do
  def router
    @router ||= Medievalistic::Router.new(test_app)
  end

  describe '#controller_class_and_action' do
    it 'raises an error when given an invalid path (i.e., an unknown controller)' do
      assert_raises(NameError) { router.controller_class_and_action('bogus/action') }
    end

    it 'returns a controller class and a symbol when given a valid path' do
      controller, action = router.controller_class_and_action('hello/world')
      assert_equal HelloController, controller
      assert_equal :world, action
    end
  end

  describe '#path_components' do
    it 'routes paths of the form /:controller/:action and invokes the right method' do
      assert_equal %w[hello world], router.path_components('/hello/world')
    end

    it 'routes paths of the form /:controller/:action and invokes the right method (with trailing slash)' do
      assert_equal %w[hello world], router.path_components('/hello/world/')
    end
    
    it 'routes paths of the form /:controller to the #index method on the appropriate controller' do
      assert_equal %w[hello index], router.path_components('/hello')
    end
    
    it 'routes paths of the form /:controller to the #index method on the appropriate controller (with trailing slash)' do
      assert_equal %w[hello index], router.path_components('/hello/')
    end

    it 'routes root paths to #index method on the "home" controller' do
      assert_equal %w[home index], router.path_components('')
      assert_equal %w[home index], router.path_components('/')
    end
  end
end
