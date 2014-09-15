$:.unshift("#{File.dirname(__FILE__)}/../src")
require 'test/unit'
require 'Deck'

class TestDeck < Test::Unit::TestCase
    def setup
        @class_under_test = Deck.new
    end

    def test_initialize
        assert_equal(52, @class_under_test.cards.length)
    end

    def test_new_deck_is_not_empty
        assert_equal(false, @class_under_test.empty?)
    end

    def test_pop
        @class_under_test.pop
        assert_equal(51, @class_under_test.cards.length)
    end
end
