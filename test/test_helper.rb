require 'rubygems'
require 'bundler'
require 'minitest/autorun'

require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. lib medievalistic]))


Hello = 'Hello, world!'
def Hello.txt
  self.dup
end
def Hello.html
  '<p>%s</p>' % self
end
Hello.freeze

def test_app
  @test_app ||= TestApp.new
end
class TestApp < Medievalistic::App; end
class HelloController < Medievalistic::Controller; end
