require 'Hand'

class Player
    attr_reader :position
    attr_accessor :money

    def initialize(position, initMoney)
        @position = position
        @hands = [Hand.new]
        @money = initMoney
    end

    def to_s
        "Player #{position}"
    end

    def hit(card)
        @hands.push(card)
    end

    def has_money_left?
        @money > 0
    end

    # Prompt the player to make a move.
    # +valid_moves+: dictionary of valid moves. The key is the letter to press for
    #                the move. The value is an informational string that informs
    #                the user what pressing the corresponding letter will do.
    #                Example: {"s"=>"stand", "d"=>"double-down"}
    def prompt_for_move(valid_moves)
        prompt_options_info_msg = valid_moves.map{|pair| "#{pair[0]} for #{pair[1]}"}.join(", ")
        prompt_keys = valid_moves.map{|pair| pair[0]}
        choice = ""
        loop do
            puts "Please make a choice"
            puts "Press #{prompt_options_info_msg}"
            choice = gets.chomp
            break if(prompt_keys.include?choice)
            puts "Sorry, invalid choice\n\n"
        end
        return choice
    end
end
