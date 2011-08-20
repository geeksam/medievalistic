require File.join(File.dirname(__FILE__), *%w[.. test_helper])
require 'rack/test'

class TestApp < Medievalistic::App
end
class HelloController < Medievalistic::Controller
  def world
    render :text => "Hello, world!"
  end
end

describe "a test application" do
  include Rack::Test::Methods
  
  def app
    TestApp.new
  end
  
  it 'works' do
    get '/hello/world'
    assert_equal "Hello, world!", last_response.body
  end
end
