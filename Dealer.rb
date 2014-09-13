require 'Deck'

class Dealer
    def initialize(players)
        @hands = []
        @deck = Deck.new
        @players = players
        @game_over = false
    end

    def to_s
        "Dealer"
    end

    def deal_to_player(player)
        2.times do
            player.hit(@deck.pop)
        end
    end

    def start_game
        start_round until @game_over
    end

    def start_round
        # recurse until done
        # loop over all players
        # remove_bankrupt_players
        # if players empty or a player chose to quit, game_over becomes true
    end

    def remove_bankrupt_players
    end
end
