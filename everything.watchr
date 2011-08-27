def run_all_tests(message = nil)
  sep = '*' * 10
  puts "\n\n#{sep}  %s  #{sep}\n" % Time.now.strftime('%I:%M:%S %p')
  puts message if message
  puts "\n"
  puts `rake test:all`
  sticky = false
  if $? == 0
    subject, message = "GREEN", "All tests passing!"
  else
    subject, message = "RED", "Test(s) failing; see Terminal for details."
  end
  `growlnotify -t "#{subject}" -m "#{message}"`
end

watch('.*') do |md|
  message = '>>> CHANGED: ' + md[0].to_s
  run_all_tests(message)
end

run_all_tests

# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    @interrupted = false
    # raise Interrupt, nil # let the run loop catch it
    run_all_tests
  end
end

