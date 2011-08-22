require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. test_helper]))
require 'rack/test'

class HelloController < Medievalistic::Controller
  def world
    render :html => Hello.html
  end
end

describe "a test application" do
  include Rack::Test::Methods
  
  def app
    test_app
  end
  
  it 'routes and renders' do
    get '/hello/world'
    assert last_response.ok?
    assert last_response.body.include?(Hello.txt)
  end
end
