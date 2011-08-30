require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. test_helper]))


class FooController < Medievalistic::Controller
end

describe Medievalistic::Router do
  def router
    @file_finder = MiniTest::Mock.new
    def @file_finder.from_root(*components)
      ''
    end
    @router ||= Medievalistic::Router.new(@file_finder)
  end

  describe '#controller_class_and_action' do
    it 'raises an error when given an invalid path (i.e., an unknown controller)' do
      assert_raises(NameError) do
        router.controller_class_and_action('bogus/action')
      end
    end

    it 'returns a controller class and a symbol when given a valid path' do
      controller, action = router.controller_class_and_action('foo/world')
      assert_equal FooController, controller
      assert_equal :world, action
    end
  end

  describe '#path_components' do
    it 'routes paths of the form /:controller/:action and invokes the right method' do
      assert_equal %w[foo world], router.path_components('/foo/world')
    end

    it 'routes paths of the form /:controller/:action and invokes the right method (with trailing slash)' do
      assert_equal %w[foo world], router.path_components('/foo/world/')
    end

    it 'routes paths of the form /:controller to the #index method on the appropriate controller' do
      assert_equal %w[foo index], router.path_components('/foo')
    end

    it 'routes paths of the form /:controller to the #index method on the appropriate controller (with trailing slash)' do
      assert_equal %w[foo index], router.path_components('/foo/')
    end

    it 'routes root paths to #index method on the "home" controller' do
      assert_equal %w[home index], router.path_components('')
      assert_equal %w[home index], router.path_components('/')
    end
  end
end
