$:.unshift("#{File.dirname(__FILE__)}/../src")
require 'test/unit'
require 'Hand'
require 'Card'
require 'Constants'
include Constants

class TestHand < Test::Unit::TestCase
    def setup
        @class_under_test = Hand.new
    end

    def test_initialize
        assert(@class_under_test.cards.empty?)
        assert_equal(0, @class_under_test.value)
        assert_equal(0, @class_under_test.bet)
    end

    def test_push
        card = Card.new(FACES[0], SUITS[0]) # card "A"
        @class_under_test.push(card)
        assert_equal(1, @class_under_test.cards.length)
        assert_equal(2, @class_under_test.value)
    end

    def test_pop
        card = Card.new(FACES[0], SUITS[0])
        @class_under_test.push(card)
        assert_equal(card, @class_under_test.pop)
        assert(@class_under_test.cards.empty?)
        assert_equal(0, @class_under_test.value)
    end

    def test_is_newly_dealt
        assert_equal(false, @class_under_test.is_newly_dealt?)

        card = Card.new(FACES[0], SUITS[0]) # card "A"
        2.times{@class_under_test.push(card)}
        assert(@class_under_test.is_newly_dealt?)
    end

    def test_has_ace
        assert_equal(false, @class_under_test.has_ace?)

        card = Card.new(FACES[-1], SUITS[0]) # card "A"
        @class_under_test.push(card)
        assert(@class_under_test.has_ace?)
    end

    def test_is_bust
        assert_equal(false, @class_under_test.is_bust?)

        card = Card.new(FACES[8], SUITS[0]) # card "10"
        3.times{@class_under_test.push(card)}
        assert(@class_under_test.is_bust?)
    end

    def test_is_blackjack
        assert_equal(false, @class_under_test.is_blackjack?)

        card = Card.new(FACES[-1], SUITS[0]) # card "A"
        @class_under_test.push(card)
        card = Card.new(FACES[8], SUITS[0]) # card "10"
        @class_under_test.push(card)
        assert(@class_under_test.is_blackjack?)
    end

    def test_can_be_split
        assert_equal(false, @class_under_test.can_be_split?)

        card = Card.new(FACES[-1], SUITS[0]) # card "A"
        2.times{@class_under_test.push(card)}
        assert(@class_under_test.can_be_split?)
    end
end
