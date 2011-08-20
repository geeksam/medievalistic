require File.join(File.dirname(__FILE__), *%w[.. test_helper])


describe Object do
  describe '#tap' do
    it 'should take a block, yield itself to the block, and return itself' do
      foo = Object.new
      returned_foo = foo.tap do |foo_in_a_box|
        assert_same foo, foo_in_a_box
        nil
      end
      assert_same foo, returned_foo
    end
  end
end


describe Array do
  describe '#extract_options!' do
    describe 'when the last element is a Hash' do
      it 'should return the last element if it is a Hash' do
        a = [:foo, { :bar => :baz }]
        assert_equal({ :bar => :baz }, a.extract_options!)
      end

      it 'should remove the last element if it is a Hash' do
        a = [:foo, { :bar => :baz }]
        a.extract_options!
        assert_equal [:foo], a
      end
    end

    describe 'when the last element is not a Hash' do
      it 'should return an empty hash' do
        assert_equal({}, [:foo].extract_options!)
      end

      it 'should leave the contents alone' do
        a = [:foo]
        a.extract_options!
        assert_equal [:foo], a
      end
    end
  end
end

def very_empty_thing
  Object.new.tap do |obj|
    def obj.empty?
      true
    end
  end
end
def not_at_all_empty_thing
  Object.new.tap do |obj|
    def obj.empty?
      false
    end
  end
end

describe '#blank?' do
  it 'is true for nil' do
    assert nil.blank?
  end

  it 'is true for things that are #empty?' do
    assert [].blank?
    assert ''.blank?
    assert very_empty_thing.blank?
  end

  it 'is true for strings that contain only whitespace' do
    assert "\t".blank?
    assert "\n".blank?
    assert "  ".blank?
  end

  it 'is false for things that are not #empty?' do
    refute [1].blank?
    refute not_at_all_empty_thing.blank?
  end

  it 'is false for strings that contain non-whitespace characters' do
    refute 'foo'.blank?
  end

  it 'is otherwise false for Object' do
    refute Object.new.blank?
  end
end

describe '#present?' do
  it 'is true for things that are not #blank?' do
    assert Object.new.present?
    assert [1].present?
    assert not_at_all_empty_thing.present?
    assert 'foo'.present?
  end

  it 'is false for things that are #blank?' do
    refute nil.present?
    refute "\t".present?
    refute "\n".present?
    refute "  ".present?
    refute [].present?
    refute ''.present?
    refute very_empty_thing.present?
  end
end
