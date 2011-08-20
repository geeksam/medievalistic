module Medievalistic
end

Dir[File.join(File.dirname(__FILE__), *%w[medievalistic *.rb])].each { |file| require file }
