require File.join(File.dirname(__FILE__), *%w[.. test_helper])

class HelloController < Medievalistic::Controller
end

describe Medievalistic::Router do
  def router
    @router ||= Medievalistic::Router.new
  end

  describe '#route' do
    it 'raises a routing error if asked for an unknown controller' do
      assert_raises(Medievalistic::RoutingError) { router.route('bogus/action') }
    end
  end

  describe '#path_components' do
    it 'routes URLs of the form /:controller/:action and invokes the right method' do
      assert_equal %w[hello world], router.send(:path_components, '/hello/world')
    end

    it 'routes URLs of the form /:controller/:action and invokes the right method (with trailing slash)' do
      assert_equal %w[hello world], router.send(:path_components, '/hello/world/')
    end
    
    it 'routes URLs of the form /:controller to the #index method on the appropriate controller' do
      assert_equal %w[hello index], router.send(:path_components, '/hello')
    end
    
    it 'routes URLs of the form /:controller to the #index method on the appropriate controller (with trailing slash)' do
      assert_equal %w[hello index], router.send(:path_components, '/hello/')
    end
  end
end
