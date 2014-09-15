$:.unshift("#{File.dirname(__FILE__)}/../src")
require 'test/unit'
require 'Player'
require 'Constants'
include Constants

class TestPlayer < Test::Unit::TestCase
    def setup
        @class_under_test = Player.new(0, INIT_MONEY)
    end

    def test_initialize
        assert_equal(0, @class_under_test.position)
        assert_equal(1, @class_under_test.hands.length)
        assert_equal(INIT_MONEY, @class_under_test.money)
    end

    def test_is_solvent
        assert_equal(true, @class_under_test.is_solvent?)

        @class_under_test.money = 0
        assert_equal(false, @class_under_test.is_solvent?)
    end

    def test_set_bet
        hand = @class_under_test.hands[0]
        bet_amount = 20
        @class_under_test.set_bet(hand, bet_amount)
        assert_equal(bet_amount, hand.bet)
    end

    def test_can_double_down_with_hand
        hand = @class_under_test.hands[0]

        assert_equal(false, @class_under_test.can_double_down_with_hand?(hand))

        hand.bet = 20
        card = Card.new(FACES[0],SUITS[0])
        2.times{hand.push(card)}
        assert(@class_under_test.can_double_down_with_hand?(hand))

        # cannot double down if the bet on the hand exceeds the amount of money
        # the player has left
        hand.reset
        hand.bet = 2*INIT_MONEY
        card = Card.new(FACES[0],SUITS[0])
        2.times{hand.push(card)}
        assert_equal(false, @class_under_test.can_double_down_with_hand?(hand))
    end

    def test_reset_hands
        @class_under_test.hands.push(Hand.new)
        assert_equal(2, @class_under_test.hands.length)

        @class_under_test.reset_hands
        assert_equal(1, @class_under_test.hands.length)
    end

    def test_double_down_on_hand
        hand = @class_under_test.hands[0]

        assert_raise(ArgumentError){@class_under_test.double_down_on_hand(hand)}
    end

    def test_can_split_hand
        hand = @class_under_test.hands[0]

        assert_equal(false, @class_under_test.can_split_hand?(hand))

        hand.bet = 20
        card = Card.new(FACES[0],SUITS[0])
        2.times{hand.push(card)}
        assert(@class_under_test.can_split_hand?(hand))

        # cannot split if the bet on the hand exceeds the amount of money
        # the player has left
        hand.reset
        hand.bet = @class_under_test.money + 1
        card = Card.new(FACES[0],SUITS[0])
        2.times{hand.push(card)}
        assert_equal(false, @class_under_test.can_double_down_with_hand?(hand))
    end

    def test_split_hand
        hand = @class_under_test.hands[0]

        assert_raise(ArgumentError){@class_under_test.split_hand(hand)}

        # make the hand eligible for splitting
        bet_amount = 20
        hand.bet = bet_amount
        card = Card.new(FACES[0],SUITS[0])
        2.times{hand.push(card)}

        new_hand = @class_under_test.split_hand(hand)
        assert_equal(INIT_MONEY - bet_amount, @class_under_test.money)
        assert_equal(bet_amount, hand.bet)
        assert_equal(bet_amount, new_hand.bet)
        assert_equal(1, hand.cards.length)
        assert_equal(2, @class_under_test.hands.length)
    end
end

