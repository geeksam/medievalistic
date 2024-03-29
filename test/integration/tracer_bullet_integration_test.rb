require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. test_helper]))
require 'rack/test'



require File.join(File.dirname(__FILE__), *%w[app_for_testing test_app])

describe "a test application" do
  include Rack::Test::Methods

  def app
    AppForTesting.new
  end

  describe "for an action with explicit content" do
    it 'routes and renders' do
      get '/hello/nurse'
      assert last_response.ok?
      assert last_response.body.include?('Hello, nurse!')
    end

    it 'renders using the default layout' do
      get '/hello/kitty_has_no_mouth'
      assert last_response.ok?
      assert_match(/<html>/, last_response.body)
      assert_match(/I'm a testing app!/, last_response.body)
    end
  end

  describe "for an action with a static view template" do
    it 'routes and renders' do
      get '/hello/kitty_has_no_mouth'
      assert last_response.ok?
      assert last_response.body.include?('Hello Kitty has no mouth, but she must scream. That is why her head is so big.')
    end

    it 'renders using the default layout' do
      get '/hello/kitty_has_no_mouth'
      assert last_response.ok?
      assert_match(/<html>/, last_response.body)
      assert_match(/I'm a testing app!/, last_response.body)
    end

    it 'renders an explicitly-named layout' do
      get 'hello/i_must_be_going'
      assert last_response.ok?
      assert_match(/<html>/, last_response.body)
      assert_match(/Phil Collins/, last_response.body)
      assert_match(/I Don't Care Anymore/, last_response.body)
    end
  end

  describe "for an action with an ERB template" do
    it 'works, and renders locals (NOT instance variables, for that is Eville.)' do
      get '/hello/is_there_anybody_in_there'
      assert last_response.ok?
      assert_match(/<div id="pink_floyd">/, last_response.body)
    end

    it 'renders locals (NOT instance variables, for that is Eville)' do
      get '/hello/is_there_anybody_in_there'
      assert last_response.ok?
      assert_match(/Just nod if you can hear me/, last_response.body)
    end
  end
end
