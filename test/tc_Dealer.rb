$:.unshift("#{File.dirname(__FILE__)}/../src")
require 'test/unit'
require 'Dealer'
require 'Constants'
include Constants

class TestDealer < Test::Unit::TestCase
    def setup
        @player = Player.new(0, INIT_MONEY)
        card = Card.new(FACES[0], SUITS[0])
        @player.hands[0].push(card)
        @player_array = [@player]
        @class_under_test = Dealer.new(@player_array)
    end

    def test_initialize_raises_argument_exception
        assert_raise(ArgumentError){Dealer.new([])}
    end

    def test_reset_player_hands
        assert_equal(1, @player.hands[0].cards.length)

        @class_under_test.reset_player_hands
        assert(0, @player.hands[0].cards.length)
    end

    def test_player_stands_with_move
        assert(@class_under_test.player_stands_with_move(STAND_KEY))
        assert_equal(false, @class_under_test.player_stands_with_move(SPLIT_KEY))
    end

    def test_player_splits_with_move
        assert(@class_under_test.player_splits_with_move(SPLIT_KEY))
        assert_equal(false, @class_under_test.player_splits_with_move(STAND_KEY))
    end

    def test_player_doubles_down_with_move
        assert(@class_under_test.player_doubles_down_with_move(DOUBLE_DOWN_KEY))
        assert_equal(false, @class_under_test.player_doubles_down_with_move(SPLIT_KEY))
    end

    def test_remove_bankrupt_players_at_end_of_round
        @class_under_test.remove_bankrupt_players_at_end_of_round
        assert_equal(1, @player_array.length)

        @player.money = 0
        @class_under_test.remove_bankrupt_players_at_end_of_round
        assert(@player_array.empty?)
    end

    def test_is_game_over_because_all_players_bankrupt
        @player.money = 0
        @class_under_test.remove_bankrupt_players_at_end_of_round
        assert(@class_under_test.is_game_over?)
    end
end

