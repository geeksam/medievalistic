require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. test_helper]))
require 'rack/test'



require File.join(File.dirname(__FILE__), *%w[app_for_testing test_app])

describe "a test application" do
  include Rack::Test::Methods

  def app
    AppForTesting.new
  end

  it 'routes and renders' do
    get '/hello/nurse'
    assert last_response.ok?
    assert last_response.body.include?('Hello, nurse!')
  end

  it 'renders a static view template' do
    get '/hello/kitty_has_no_mouth'
    assert last_response.ok?
    assert last_response.body.include?('Hello Kitty has no mouth, but she must scream. That is why her head is so big.')
  end

  it 'renders in a layout' do
    get '/hello/kitty_has_no_mouth'
    assert last_response.ok?
    assert_match /<html>/, last_response.body
  end
end
