require File.join(File.dirname(__FILE__), *%w[.. test_helper])

class HelloController < Medievalistic::Controller
end

describe Medievalistic::Controller do
  describe '#render' do
    before do
      @response = MiniTest::Mock.new
      @controller = HelloController.new(nil, @response)
      def @response.expect_content_and_type(content, type)
        expect :write, content, [content]
        expect :[]=, type, ['Content-Type', type]
        yield
        verify
      end
    end

    it 'raises a DoubleRenderError when you call render more than once' do
      def @controller.goodbye
        render :html => 'Unce'
        render :html => 'Tice'
        render :html => 'Fee Times a Mady'
      end

      assert_raises(Medievalistic::Controller::DoubleRenderError) do
        @controller.response.expect_content_and_type 'Unce', 'text/html' do
          @controller.goodbye
        end
      end
    end

    describe 'with only hash-style arguments' do
      it 'renders :text => nil and sets content type to text/plain' do
        def @controller.goodbye
          render :text => nil
        end

        @controller.response.expect_content_and_type nil, 'text/plain' do
          @controller.goodbye
        end
      end

      it 'renders :text => "" and sets content type to text/plain' do
        def @controller.goodbye
          render :text => ''
        end

        @controller.response.expect_content_and_type '', 'text/plain' do
          @controller.goodbye
        end
      end

      it 'renders :text => "foo" and sets content type to text/plain' do
        def @controller.goodbye
          render :text => Hello.txt
        end

        @controller.response.expect_content_and_type Hello.txt, 'text/plain' do
          @controller.goodbye
        end
      end

      it 'renders :html => "foo" and sets content type to text/html' do
        def @controller.goodbye
          render :html => Hello.html
        end

        @controller.response.expect_content_and_type Hello.html, 'text/html' do
          @controller.goodbye
        end
      end

      it 'raises a DoubleRenderError when you call render with more than one format key' do
        def @controller.goodbye
          render :text => 'I am text', :html => 'I am HTML'
        end

        assert_raises(Medievalistic::Controller::DoubleRenderError) do
          @controller.response.expect_content_and_type 'I am HTML', 'text/html' do
            @controller.goodbye
          end
        end
      end
    end

    describe 'with no arguments' do
      it 'renders a template' do
        flunk "Continue here"
      end
    end
  end
end
