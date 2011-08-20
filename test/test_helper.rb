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
