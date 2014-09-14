$:.unshift('.') # include cwd in path
require 'Hand'

=begin rdoc
A player may have many hands (depending on how many times he splits it). (Contrast
this with the dealer who always has only one hand)
=end
class Player
    attr_reader :position, :hands
    attr_accessor :money

    def initialize(position, initMoney)
        @position = position
        @hands = [Hand.new]
        @money = initMoney
    end

    def to_s
        "Player #{position}"
    end

    def clear_hands
        @hands.map{|hand| hand.reset}
    end

    def is_not_bankrupt?
        @money > 0
    end

    # Prompt the player to make a move.
    # +valid_moves_map+: dictionary of valid moves. The key is the letter to press for
    #                    the move. The value is an informational string that informs
    #                    the user what pressing the corresponding letter will do.
    #                    Example: {"s"=>"stand", "d"=>"double-down"}
    def prompt_for_move(valid_moves_map)
        prompt_options_info_msg = valid_moves_map.map{|pair| "#{pair[0]} for #{pair[1]}"}.join(", ")
        choice = ""
        loop do
            puts "Please make a choice"
            puts "Press #{prompt_options_info_msg}"
            choice = gets.chomp
            break if(valid_moves_map.has_key?choice)
            puts "Sorry, invalid choice\n\n"
        end
        puts ""
        return choice
    end

    def set_bet_on_hand(hand)
        set_bet_on_hand_upto(hand, @money)
    end

    def set_double_down_bet_on_hand(hand)
        set_bet_on_hand_upto(hand, hand.bet)
    end

    def set_bet_on_hand_upto(hand, bet_limit)
        bet = 0
        loop do
            puts "How much would you like to bet on this hand? You can bet up to $#{bet_limit}"
            bet = gets.chomp.to_i
            break if bet > 0 && bet <= bet_limit
            puts "Sorry, invalid bet amount. You can bet up to $#{bet_limit}\n\n"
        end
        @money -= bet
        hand.bet += bet

        puts "Thank you, you have $#{@money} left\n\n"
    end

    def double_down_on_hand(hand)
        puts "Doubling down on your hand"
        @money -= hand.bet
        hand.bet *= 2
        puts "Your bet is now #{hand.bet}; you have $#{@money} left\n\n"
    end

    def can_double_down_with_hand?(hand)
        hand.is_newly_dealt? && hand.bet <= @money
    end

    def split_hand(hand)
        puts "Splitting your hand. No resplits are allowed."
        new_hand = Hand.new
        new_hand.bet = hand.bet
        new_hand.push(hand.pop)
        @hands.push(new_hand)
        return new_hand
    end

    def can_split_hand?(hand)
        hand.can_be_split? && hand.bet <= @money
    end
end
