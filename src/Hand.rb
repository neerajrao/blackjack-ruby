$:.unshift("#{File.dirname(__FILE__)}") # add source directory to path
require 'Constants'
include Constants

=begin rdoc
Code is written to be self-documenting.

Methods are named similary to Ruby built-ins so they are easy
to remember. E.g. pop to take a card from the hand, push to
add a card to the hand etc

This class represents a player's or a dealer's hand. A hand has
a number of playing cards, an associated value (that is a function
of its constituent cards) as well as an associated bet amount.

This class also has convenience methods to determine whether it
is eligible to be split or to check if it makes a Blackjack/natural.
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

        # if the hand has a hole card (only for dealer's hands), hide its value before printing
        possible_hole_card = @cards[1]
        hand_value = @value
        hand_value -= possible_hole_card.value if possible_hole_card && possible_hole_card.is_hole_card

        repr = "Hand cards: #{@cards.join(', ')}\n" +
               "Hand value: #{hand_value}\n" +
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
