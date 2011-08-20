# Many of these were lovingly swiped from ActiveSupport.

firsts = %w[object].map { |e| File.join(File.dirname(__FILE__), 'core_ext', e + '.rb') }
rest = Dir[File.join(File.dirname(__FILE__), *%w[core_ext *.rb])] - firsts

core_extensions = firsts + rest

core_extensions.each { |ext| require ext }
