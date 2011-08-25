require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. test_app.rb]))

class HelloController < Medievalistic::Controller
  def nurse
    render '<div class="greeting">Hello, nurse!</div>'
  end

  def kitty_has_no_mouth
    render
  end
end
