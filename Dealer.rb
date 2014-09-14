$:.unshift('.') # include cwd in path
require 'Deck'
require 'Constants'
include Constants

class Dealer
    def initialize(players)
        @hand = Hand.new # dealer always has only one hand
        @deck = Deck.new
        @players = players
        @game_over = false
    end

    def play_game
        puts "Dealer is starting game...\n"
        play_round until @game_over
        puts "Game over. Thanks for playing!\n\n"
    end

    def play_round
        puts "\nStarting a new round..."
        puts "-------------------------\n\n"

        @players.map{|player| player.clear_hands}

        @players.each do |player|
            puts "#{player}"
            player.hands.each do |hand|
                deal_initial_cards_to_hand(hand)
                puts hand

                player.set_bet_on_hand(hand)

                end_hand = false
                until end_hand
                    puts hand
                    valid_moves_map = build_valid_moves_map_for_hand(player, hand)
                    move = player.prompt_for_move(valid_moves_map)

                    if move == STAND_KEY
                        end_hand = true
                    elsif move == DOUBLE_DOWN_KEY
                        player.double_down_on_hand(hand)
                        deal_to_hand(hand)
                        puts hand
                        end_hand = true
                    elsif move == SPLIT_KEY
                        new_hand = player.split_hand(hand)
                        deal_to_hand(hand)
                        deal_to_hand(new_hand)
                        puts hand
                        puts new_hand
                        end_hand = true if hand.is_bust?
                    else
                        deal_to_hand(hand)
                        puts hand
                        end_hand = true if hand.is_bust?
                    end
                end
            end
        end

        deal_to_self

        settle_bets_at_end_of_round

        remove_bankrupt_players_at_end_of_round

        @game_over = is_game_over?

        unless @game_over
            #TODO: reset all hands, including dealer's so we can play another round
        end
    end

    def deal_initial_cards_to_hand(hand)
        2.times{deal_to_hand(hand)}
    end

    def deal_to_hand(hand)
        card = @deck.pop
        hand.push(card)
    end

    def build_valid_moves_map_for_hand(player, hand)
        valid_moves_map = STAND_KEY_DESCR_MAP.merge(HIT_KEY_DESCR_MAP)
        valid_moves_map.merge!(DOUBLE_DOWN_KEY_DESCR_MAP) if player.can_double_down_with_hand?(hand)
        valid_moves_map.merge!(SPLIT_KEY_DESCR_MAP) if player.can_split_hand?(hand)
        return valid_moves_map
    end

    def deal_to_self
        until self.should_stand?
            deal_to_hand(@hand)
        end
        puts "Dealer's hand"
        puts "#{@hand}"
    end

    def settle_bets_at_end_of_round
        # TODO: pay out or collect. don't forget ties
    end

    def remove_bankrupt_players_at_end_of_round
        @players = @players.select {|player| player.is_not_bankrupt?}
    end

    def to_s
        "Dealer"
    end

    def should_stand?
        @hand.value >= STAND_VALUE
    end

    def is_game_over?
        return true if @players.empty?
        return ask_if_end_game?
    end

    def ask_if_end_game?
        play_another_round = ""
        loop do
            puts "Would you like to play another round? (y/n)"
            play_another_round = gets.chomp
            break if (play_another_round == "y" || play_another_round == "n")
            puts "Invalid choice. Please press either 'y' or 'n'."
        end
        puts

        if(play_another_round == "n")
            return true
        else
            return false
        end
    end
end
