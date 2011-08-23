require 'rubygems'
require 'bundler'
require 'minitest/autorun'

require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. lib medievalistic]))


Foo = 'Foo!'
def Foo.txt
  self.dup
end
def Foo.html
  '<p>%s</p>' % self
end
Foo.freeze

def test_app
  @test_app ||= begin
    app_klass = Class.new(Medievalistic::App)
    app_klass.new
  end
end
