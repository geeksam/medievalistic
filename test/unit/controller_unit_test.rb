require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. test_helper]))


class FooController < Medievalistic::Controller
end

describe Medievalistic::Controller do
  describe '#render' do
    before do
      @doublemeat_medley = MiniTest::Mock.new
      @controller = FooController.new(@doublemeat_medley)
      def @doublemeat_medley.expect_write_content_and_type(content, type)
        expect :write_type_and_content, content, [type, content]
        yield
        verify
      end
    end

    it 'raises a DoubleRenderError when you call render more than once' do
      def @controller.goodbye
        render 'Unce'
        render 'Tice'
        render 'Fee Times a Mady'
      end

      assert_raises(Medievalistic::Controller::DoubleRenderError) do
        @doublemeat_medley.expect_write_content_and_type 'Unce', 'text/html' do
          @controller.goodbye
        end
      end
    end

    describe '#render' do
      it 'takes args ("foo") and writes to the tubes with appropriate content type' do
        def @controller.goodbye
          render Foo.html
        end

        @doublemeat_medley.expect_write_content_and_type Foo.html, 'text/html' do
          @controller.goodbye
        end
      end
    end

    describe '#render_as' do
      it 'takes args (:text, nil) and writes to the tubes with appropriate content type' do
        def @controller.goodbye
          render_as :text, nil
        end

        @doublemeat_medley.expect_write_content_and_type nil, 'text/plain' do
          @controller.goodbye
        end
      end

      it 'takes args (:text, "") and writes to the tubes with appropriate content type' do
        def @controller.goodbye
          render_as :text, ""
        end

        @doublemeat_medley.expect_write_content_and_type '', 'text/plain' do
          @controller.goodbye
        end
      end

      it 'takes args (:text, "foo") and writes to the tubes with appropriate content type' do
        def @controller.goodbye
          render_as :text, Foo.txt
        end

        @doublemeat_medley.expect_write_content_and_type Foo.txt, 'text/plain' do
          @controller.goodbye
        end
      end

      it 'takes args (:html, "foo") and writes to the tubes with appropriate content type' do
        def @controller.goodbye
          render_as :html, Foo.html
        end

        @doublemeat_medley.expect_write_content_and_type Foo.html, 'text/html' do
          @controller.goodbye
        end
      end
    end
  end
end
