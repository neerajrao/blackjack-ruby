$:.unshift('.') # include cwd in path
require 'Deck'

class Card
    attr_reader :value

    def initialize(faceval, suit)
        unless Deck::FACES.include?faceval
            raise ArgumentError.new("Face value must be one of: #{Deck::FACES.join(", ")}")
        end

        unless Deck::SUITS.include?suit
            raise ArgumentError.new("Suit must be one of: #{Deck::SUITS.join(", ")}")
        end

        @face = "#{faceval.to_s} #{suit}"
        case faceval
        when 2..10: @value = faceval
        when "J": @value = 10
        when "Q": @value = 10
        when "K": @value = 10
        when "A": @value = 1
        end
    end

    def to_s
        @face
    end
end
