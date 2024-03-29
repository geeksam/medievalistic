require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. test_helper]))


class FooController < Medievalistic::Controller
end

describe Medievalistic::Controller do
  describe '#render' do
    before do
      @doublemeat_medley = MiniTest::Mock.new
      def @doublemeat_medley.expect_write_type_and_content(content, type)
        expect :write_type_and_content, content, [type, content]
        yield
        verify
      end

      @controller = FooController.new(@doublemeat_medley, nil)
      view = @controller.send(:view)
      def view.wrap_content_in_layout(content, layout)
        content  # just skip that whole Tilt business
      end
    end

    it 'raises a DoubleRenderError when you call render more than once' do
      def @controller.goodbye
        render 'Unce'
        render 'Tice'
        render 'Fee Times a Mady'
      end

      assert_raises(Medievalistic::Controller::DoubleRenderError) do
        @doublemeat_medley.expect_write_type_and_content 'Unce', 'text/html' do
          @controller.goodbye
        end
      end
    end

    it 'takes args (content) and writes to the tubes with default content type of HTML' do
      def @controller.goodbye
        render Foo.html
      end

      @doublemeat_medley.expect_write_type_and_content Foo.html, 'text/html' do
        @controller.goodbye
      end
    end

    it 'Does the Right Thing(tm) when given args (content, :format => :text)' do
      def @controller.foo_text; render Foo.txt,  :format => :text; end

      @doublemeat_medley.expect_write_type_and_content Foo.txt, 'text/plain' do
        @controller.foo_text
      end
    end

    it 'Does the Right Thing(tm) when given args (content, :format => :html)' do
      def @controller.foo_html; render Foo.html, :format => :html; end

      @doublemeat_medley.expect_write_type_and_content Foo.html, 'text/html' do
        @controller.foo_html
      end
    end
  end
end
