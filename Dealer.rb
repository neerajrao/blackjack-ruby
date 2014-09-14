require 'Deck'

class Dealer
    def initialize(players)
        @hand = [] #dealer always has only one hand
        @deck = Deck.new
        @players = players
        @game_over = false
    end

    def start_game
        play_round until @game_over
    end

    def play_round
        # loop over all players
        #   deal cards to each deck of player
        #   show player his hand
        #   ask player for move
        #   if player decides to quit, set game_over to true, break out of the loop
        # once all players are done, hit yourself till over 17
        # show everyone your hand
        # pay out or collect money
        # remove_bankrupt_players
        # if players empty or a player chose to quit, game_over becomes true
    end

    def deal_to_player(player)
        2.times do
            player.hit(@deck.pop)
        end
    end

    def remove_bankrupt_players
    end

    def to_s
        "Dealer"
    end
end
