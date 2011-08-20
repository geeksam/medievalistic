require File.join(File.dirname(__FILE__), *%w[.. test_helper])

class HelloController < Medievalistic::Controller
  def world
    render :text => "Hello, world!"
  end
end

describe Medievalistic::Controller do

  it 'renders :text => "foo"' do
    flunk "continue here, perhaps"
  end

end
