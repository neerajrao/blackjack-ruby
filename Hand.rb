$:.unshift('.') # include cwd in path
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
    end

    def to_s
        repr = "Here is your hand:\n" +
               "------------------\n" +
               "Hand cards: #{@cards.join(', ')}\nHand value: #{@value}"
        @bet>0? repr+"\nBet on hand: $#{@bet}\n\n":repr+"\n\n" # show bet if non-zero
    end

    def push(card)
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
        @value > MAX_VALUE
    end

    def is_blackjack?
        #TODO
    end
end
