require File.join(File.dirname(__FILE__), *%w[.. test_helper])
require 'rack/test'

class TestApp < Medievalistic::App
end

describe "a test application" do
  include Rack::Test::Methods
  
  def app
    TestApp.new
  end
  
  # it 'runs' do
  #   get '/'
  #   assert last_response.ok?
  # end

  it 'raises a routing error if asked for an unknown controller' do
    assert_raises(Medievalistic::RoutingError) { get 'bogus/action' }
  end
  
end
