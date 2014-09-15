$:.unshift('.') # include cwd in path
require 'Card'
require 'Constants'
include Constants

=begin rdoc
A key assumption is a Deck has enough cards for the game to end.
Methods are named similary to Ruby built-ins so they are easy
to remember. E.g. pop to take a card from the deck, empty? to
check if the deck is empty etc.
=end
class Deck
    attr_accessor :cards
    def initialize
        reset
    end

    def reset
        @cards = create_52_card_deck()
        @cards.shuffle!
    end

    def create_52_card_deck
        SUITS.map{|suit| FACES.map{|face| Card.new(face, suit)}}.flatten
    end

    def to_s
        @cards.join(", ")
    end

    def empty?
        @cards.empty?
    end

    # if deck is empty, re-init the deck. This way, the deck never runs out of cards
    def pop
        reset if empty?
        @cards.pop
    end
end
