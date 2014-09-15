$:.unshift("#{File.dirname(__FILE__)}/../src")
require 'test/unit'
require 'Card'
require 'Constants'
include Constants

class TestCard < Test::Unit::TestCase
    def setup
        @class_under_test = Card.new(FACES[0],SUITS[0])
    end

    def test_initialize_raises_argument_exception
        assert_raise(ArgumentError){Card.new("random_string",SUITS[0])}
    end

    def test_value
        assert_equal(FACES[0], @class_under_test.value)
    end

    def test_to_s
        assert_equal("#{FACES[0]} #{SUITS[0]}", "#{@class_under_test}")
    end

    def test_is_ace
        assert_equal(false, @class_under_test.is_ace)

        @class_under_test = Card.new(FACES[-1],SUITS[0])
        assert(@class_under_test.is_ace)
    end
end
