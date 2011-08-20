require File.join(File.dirname(__FILE__), *%w[.. test_helper])
require 'rack/test'

class TestApp < Medievalistic::App
end

describe "a test application" do
  include Rack::Test::Methods
  
  def app
    TestApp.new
  end
  
  it 'works' do
    flunk
  end
  
end
