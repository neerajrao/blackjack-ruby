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

    def make_move
    end
end
