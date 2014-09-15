$:.unshift("#{File.dirname(__FILE__)}") # add source directory to path
require 'Deck'

=begin rdoc
Code is written to be self-documenting.

This class represents a playing card. It has a value as per
standard Blackjack rules, as well as a string representation for
printing.
=end

class Card
    attr_reader :value, :is_ace

    def initialize(faceval, suit)
        unless Deck::FACES.include?faceval
            raise ArgumentError.new("Face value must be one of: #{FACES.join(", ")}")
        end

        unless Deck::SUITS.include?suit
            raise ArgumentError.new("Suit must be one of: #{SUITS.join(", ")}")
        end

        @face = "#{faceval.to_s} #{suit}"
        @is_ace = false
        case faceval
        when 2..10: @value = faceval
        when "J": @value = 10
        when "Q": @value = 10
        when "K": @value = 10
        when "A"
            @value = 11
            @is_ace = true
        end
    end

    def to_s
        @face
    end
end
