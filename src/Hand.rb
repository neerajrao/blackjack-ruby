$:.unshift("#{File.dirname(__FILE__)}") # add source directory to path
require 'Constants'
include Constants

=begin rdoc
Methods are named similary to Ruby built-ins so they are easy
to remember. E.g. push to add a card to the deck
=end
class Hand
    attr_accessor :bet
    attr_reader :cards, :value

    def initialize
        reset
    end

    def reset
        @cards = []
        @value = 0
        @bet = 0
        @num_aces = 0
    end

    def to_s
        bet_display_value = "Bet on hand: #{@bet}\n" if @bet > 0

        repr = "Hand cards: #{@cards.join(', ')}\n" +
               "Hand value: #{@value}\n" +
               "#{bet_display_value}\n"
    end

    def push(card)
        @num_aces += 1 if card.is_ace

        @cards.push(card)
        @value += card.value
        #TODO: Aces should count as 11 or 1
    end

    def pop
        card = @cards.pop
        @value -= card.value
        return card
    end

    def is_newly_dealt?
        @cards.length == 2
    end

    # all 10-value cards are treated as the same for a split
    # E.g. a 10 and a J pair is eligible for a split
    def can_be_split?
        is_newly_dealt? && @cards[-1].value == @cards[-2].value
    end

    def is_bust?
        @value > BLACKJACK_VALUE
    end

    def has_ace?
        @num_aces > 0
    end

    def is_blackjack?
        is_newly_dealt? &&
        @num_aces == 1 && # blackjack can only have one ace
        @value == BLACKJACK_VALUE
    end
end
